define ->
  _ = require 'underscore'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  Column = require 'models/column'
  UserStory = require 'models/user_story'
  BoardView = require 'views/board/board_view'
  ColumnPageView = require 'views/board/column_page_view'

  class BoardController extends SiteController
    index: (params) ->
      field = app.session.get('boardField')
      columns = _.map UserStory::allowedValues[field], (value) -> new Column(field: field, value: value)

      @afterProjectLoaded =>
        col.fetch(@getFetchData(field, col.get('value'))) for col in columns
        @view = new BoardView autoRender: true, columns: columns, field: field

        @listenTo @view, 'columnClick', @onColumnClick

    column: (params) ->
      field = app.session.get('boardField')
      colValue = params.column
      
      @afterProjectLoaded =>
        col = new Column(field: field, value: colValue)
        col.fetch @getFetchData(field, colValue)

        @view = new ColumnPageView autoRender: true, model: col
        @listenTo @view, 'cardClick', @onCardClick

    onColumnClick: (col) =>
      colValue = col.get('value')
      @redirectToRoute 'board#column', column: colValue

    onCardClick: (oid, type) =>
      mappedType = @getRouteTypeFromModelType(type)
      @redirectToRoute "#{mappedType}#show", id: oid

    getFetchData: (field, value) ->
      data =
        fetch: ['ObjectID', 'FormattedID', 'Rank'].join ','
        query: "(#{field} = \"#{value}\")"
        project: app.session.project.get('_ref')
        projectScopeUp: false
        projectScopeDown: true
        order: "Rank DESC"

      if app.session.isSelfMode()
        data.query = "(#{data.query} AND (Owner = #{app.session.get('user').get('_ref')}))"

      data

    getRouteTypeFromModelType: (type = 'hierarchicalrequirement') ->
      routeTypes =
        hierarchicalrequirement: 'user_story_detail'
        defect: 'defect_detail'

      routeTypes[type.toLowerCase()]