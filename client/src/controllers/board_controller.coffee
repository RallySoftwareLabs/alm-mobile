define ->
  _ = require 'underscore'
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
        @view = @renderReactComponent BoardView, columns: columns, region: 'main'

        @subscribeEvent 'headerclick', @onColumnClick
        @subscribeEvent 'cardclick', @onCardClick

    column: (colValue) ->
      
      @whenLoggedIn =>
        @updateTitle app.session.getProjectName()

        field = app.session.get('boardField')
        col = new Column(field: field, value: colValue)
        col.fetch @getFetchData(field, colValue)

        @view = @renderReactComponent ColumnView,
          region: 'main'
          model: col
          columns: @getColumnModels(field)
          singleColumn: true
          abbreviateHeader: false
          showIteration: true
        

        @subscribeEvent 'headerclick', @onColumnClick
        @subscribeEvent 'cardclick', @onCardClick
        @subscribeEvent 'goleft', @goLeft
        @subscribeEvent 'goright', @goRight

    onColumnClick: (col) ->
      colValue = col.get('value')
      @redirectTo "board/#{colValue}"

    onCardClick: (oid, type) ->
      mappedType = @getRouteTypeFromModelType(type)
      @redirectTo "#{mappedType}/#{oid}"

    goLeft: (col) ->
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, (c) -> c.get('value') == col.get('value')
      if colIndex > 0
        newColumn = columns[colIndex - 1]
        @redirectTo "/board/#{newColumn.get('value')}"
        @view.setProps model: newColumn

    goRight: (col) ->
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, (c) -> c.get('value') == col.get('value')
      if colIndex < columns.length - 1
        newColumn = columns[colIndex + 1]
        @redirectTo "/board/#{newColumn.get('value')}"

    getColumnModels: (field) ->
      _.map app.session.getBoardColumns(), (value) -> new Column(field: field, value: value)

    getFetchData: (field, value) ->
      data =
        fetch: ['ObjectID', 'FormattedID', 'Rank', 'DisplayColor', 'Blocked', 'Ready', 'Name', 'Owner'].join ','
        query: "((#{field} = \"#{value}\") AND ((Requirement = null) OR (DirectChildrenCount = 0)))"
        types: 'hierarchicalrequirement,defect'
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
        hierarchicalrequirement: 'userstory'
        defect: 'defect'

      routeTypes[type.toLowerCase()]