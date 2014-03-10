define ->
  _ = require 'underscore'
  app = require 'application'
  utils = require 'lib/utils'
  SiteController = require 'controllers/base/site_controller'
  Artifacts = require 'collections/artifacts'
  Column = require 'models/column'
  UserStory = require 'models/user_story'
  BoardView = require 'views/board/board'
  ColumnView = require 'views/board/column'

  class BoardController extends SiteController
    index: (params) ->
      @whenProjectIsLoaded =>
        field = app.session.get('boardField')
        columns = @getColumnModels field
        artifacts = new Artifacts()
        artifacts.clientMetricsParent = this

        $.when(
          artifacts.fetch(@getFetchData(field, app.session.getBoardColumns()))
        ).always =>
          artifacts.each (artifact) ->
            column = _.find columns, (column) ->
              column.get('value') == artifact.get(field)
            
            column.artifacts.add artifact
          _.invoke(columns, 'trigger', 'sync')
          @markFinished()

        @view = @renderReactComponent BoardView, columns: columns, region: 'main'

        @subscribeEvent 'headerclick', @onColumnClick
        @subscribeEvent 'cardclick', @onCardClick

    column: (colValue) ->
      
      @whenProjectIsLoaded =>
        @updateTitle app.session.getProjectName()

        field = app.session.get('boardField')
        col = new Column(field: field, value: colValue)
        col.artifacts.clientMetricsParent = this
        options = @getFetchData(field, [colValue])
        col.artifacts.fetch(options).always =>
          col.trigger('sync', col, options)
          @markFinished()

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

    onCardClick: (view, model) ->
      @redirectTo utils.getDetailHash(model)

    goLeft: (col) ->
      field = app.session.get('boardField')
      columns = @getColumnModels field
      colIndex = _.findIndex columns, _.isAttributeEqual('value', col.get('value'))
      if colIndex > 0
        newColumn = columns[colIndex - 1]
        @redirectTo "/board/#{newColumn.get('value')}"
        @view.setProps model: newColumn

    goRight: (col) ->
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

    getFetchData: (field, values) ->
      colQuery = utils.createQueryFromCollection(values, field, 'OR', (value) ->
        "\"#{value}\""
      )
      data =
        fetch: "FormattedID,DisplayColor,Blocked,Ready,Name,Owner,#{field}"
        query: "(#{colQuery} AND ((Requirement = null) OR (DirectChildrenCount = 0)))"
        types: 'hierarchicalrequirement,defect'
        order: "Rank ASC"
        pagesize: 100
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true

      if app.session.isSelfMode()
        data.query = "(#{data.query} AND (Owner = #{app.session.get('user').get('_ref')}))"

      iterationRef = app.session.get('iteration')?.get('_ref')
      if iterationRef
        data.query = "(#{data.query} AND (Iteration = \"#{iterationRef}\"))"

      data: data
