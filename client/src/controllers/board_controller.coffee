define [
  'underscore'
  'application'
  'controllers/base/site_controller'
  'models/column'
  'models/user_story'
  'views/board/board_view'
  'views/board/column_page_view'
], (_, app, SiteController, Column, UserStory, BoardView, ColumnPageView) ->

  class BoardController extends SiteController
    index: (params) ->
      field = 'ScheduleState'
      columns = _.map UserStory::allowedValues[field], (value) -> new Column(field: field, value: value)

      @afterProjectLoaded =>
        col.fetch(@getFetchData(field, col.get('value'))) for col in columns
        @view = new BoardView autoRender: true, columns: columns, field: field

        @listenTo @view, 'columnClick', @onColumnClick

    column: (params) ->
      field = 'ScheduleState'
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
      fetch: ['ObjectID', 'FormattedID', 'DragAndDropRank'].join ','
      query: "(#{field} = \"#{value}\")"
      project: app.session.project.get('_ref')
      projectScopeUp: false
      projectScopeDown: true
      order: "DragAndDropRank DESC"

    getRouteTypeFromModelType: (type = 'hierarchicalrequirement') ->
      routeTypes =
        hierarchicalrequirement: 'user_story_detail'
        defect: 'defect_detail'

      routeTypes[type.toLowerCase()]