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
      @whenProjectIsLoaded =>
        field = app.session.get('boardField')
        columns = @getColumnModels field

        $.when.apply($,
          _.map columns, (col) => col.fetch(@getFetchData(field, col.get('value')))
        ).always => @markFinished()

        @view = @renderReactComponent BoardView, columns: columns, region: 'main'

        @subscribeEvent 'headerclick', @onColumnClick
        @subscribeEvent 'cardclick', @onCardClick

    column: (colValue) ->
      
      @whenProjectIsLoaded =>
        @updateTitle app.session.getProjectName()

        field = app.session.get('boardField')
        col = new Column(field: field, value: colValue)
        col.clientMetricsParent = this
        col.fetch(@getFetchData(field, colValue)).always => @markFinished()

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
      app.aggregator.recordAction component: this, description: 'clicked column'
      colValue = col.get('value')
      @redirectTo "board/#{colValue}"

    onCardClick: (oid, type) ->
      app.aggregator.recordAction component: this, description: 'clicked card'
      mappedType = @getRouteTypeFromModelType(type)
      @redirectTo "#{mappedType}/#{oid}"

    goLeft: (col) ->
      app.aggregator.recordAction component: this, description: 'clicked left on column'
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, _.isAttributeEqual('value', col.get('value'))
      if colIndex > 0
        newColumn = columns[colIndex - 1]
        @redirectTo "/board/#{newColumn.get('value')}"
        @view.setProps model: newColumn

    goRight: (col) ->
      app.aggregator.recordAction component: this, description: 'clicked right on column'
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, _.isAttributeEqual('value', col.get('value'))
      if colIndex < columns.length - 1
        newColumn = columns[colIndex + 1]
        @redirectTo "/board/#{newColumn.get('value')}"

    getColumnModels: (field) ->
      _.map app.session.getBoardColumns(), (value) =>
          col = new Column({field, value})
          col.clientMetricsParent = this
          col

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