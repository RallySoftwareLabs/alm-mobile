define ->
  _ = require 'underscore'
  React = require 'react'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  Column = require 'models/column'
  UserStory = require 'models/user_story'
  BoardView = require 'views/board/board'
  ColumnView = require 'views/board/column'

  class BoardController extends SiteController
    index: (params) ->
      @whenLoggedIn =>
        field = app.session.get('boardField')
        columns = @getColumnModels field

        col.fetch(@getFetchData(field, col.get('value'))) for col in columns
        @view = React.renderComponent(BoardView(columns: columns), document.getElementById('content'))

        @listenTo @view, 'headerclick', @onColumnClick
        @listenTo @view, 'cardclick', @onCardClick

    column: (params) ->
      colValue = decodeURI(params.column)
      
      @whenLoggedIn =>
        @updateTitle app.session.getProjectName()

        field = app.session.get('boardField')
        col = new Column(field: field, value: colValue)
        col.fetch @getFetchData(field, colValue, ['Name', 'Owner'])

        @view = React.renderComponent(ColumnView(model: col, columns: @getColumnModels(field), showFields: true, abbreviateHeader: false, showIteration: true), document.getElementById('content'))

        @listenTo @view, 'headerclick', @onColumnClick
        @listenTo @view, 'cardclick', @onCardClick
        @listenTo @view, 'goleft', @goLeft
        @listenTo @view, 'goright', @goRight

    onColumnClick: (col) ->
      colValue = col.get('value')
      @redirectToRoute 'board#column', column: colValue

    onCardClick: (oid, type) ->
      mappedType = @getRouteTypeFromModelType(type)
      @redirectToRoute "#{mappedType}#show", id: oid

    goLeft: (col) ->
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, (c) -> c.get('value') == col.get('value')
      if colIndex > 0
        @redirectToRoute 'board#column', column: columns[colIndex - 1].get('value')

    goRight: (col) ->
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, (c) -> c.get('value') == col.get('value')
      if colIndex < columns.length - 1
        @redirectToRoute 'board#column', column: columns[colIndex + 1].get('value')

    getColumnModels: (field) ->
      _.map app.session.getBoardColumns(), (value) -> new Column(field: field, value: value)

    getFetchData: (field, value, extraFetch = []) ->
      data =
        fetch: ['ObjectID', 'FormattedID', 'Rank', 'DisplayColor', 'Blocked', 'Ready'].concat(extraFetch).join ','
        query: "(#{field} = \"#{value}\")"
        order: "Rank ASC,ObjectID"
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true

      if app.session.isSelfMode()
        data.query = "(#{data.query} AND (Owner = #{app.session.get('user').get('_ref')}))"

      iterationRef = app.session.get('iteration')?.get('_ref')
      if iterationRef
        data.query = "(#{data.query} AND (Iteration = \"#{iterationRef}\"))"

      data

    getRouteTypeFromModelType: (type = 'hierarchicalrequirement') ->
      routeTypes =
        hierarchicalrequirement: 'user_story_detail'
        defect: 'defect_detail'

      routeTypes[type.toLowerCase()]