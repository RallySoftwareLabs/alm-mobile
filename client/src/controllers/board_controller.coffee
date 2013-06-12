define ->
  _ = require 'underscore'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  Column = require 'models/column'
  UserStory = require 'models/user_story'
  BoardPageView = require 'views/board/board_page_view'
  ColumnPageView = require 'views/board/column_page_view'

  class BoardController extends SiteController
    index: (params) ->
      field = app.session.get('boardField')
      @afterProjectLoaded =>
        columns = _.map _.pluck(UserStory.getAllowedValues(field), 'StringValue'), (value) -> new Column(field: field, value: value)

        col.fetch(@getFetchData(field, col.get('value'))) for col in columns
        @view = new BoardPageView autoRender: true, columns: columns, field: field

        @listenTo @view, 'headerclick', @onColumnClick
        @listenTo @view, 'cardclick', @onCardClick

    column: (params) ->
      field = app.session.get('boardField')
      colValue = decodeURI(params.column)
      
      @afterProjectLoaded =>
        col = new Column(field: field, value: colValue)
        col.fetch @getFetchData(field, colValue, ['Name', 'Owner'])

        @view = new ColumnPageView autoRender: true, model: col
        @listenTo @view, 'headerclick', @onColumnClick
        @listenTo @view, 'cardclick', @onCardClick

    onColumnClick: (col) =>
      colValue = col.get('value')
      @redirectToRoute 'board#column', column: colValue

    onCardClick: (oid, type) =>
      mappedType = @getRouteTypeFromModelType(type)
      @redirectToRoute "#{mappedType}#show", id: oid

    getFetchData: (field, value, extraFetch = []) ->
      data =
        fetch: ['ObjectID', 'FormattedID', 'Rank', 'DisplayColor'].concat(extraFetch).join ','
        query: "(#{field} = \"#{value}\")"
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true

      if app.session.isSelfMode()
        data.query = "(#{data.query} AND (Owner = #{app.session.get('user').get('_ref')}))"

      data

    getRouteTypeFromModelType: (type = 'hierarchicalrequirement') ->
      routeTypes =
        hierarchicalrequirement: 'user_story_detail'
        defect: 'defect_detail'

      routeTypes[type.toLowerCase()]