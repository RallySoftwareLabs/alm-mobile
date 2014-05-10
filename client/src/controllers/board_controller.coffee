_ = require 'underscore'
app = require 'application'
utils = require 'lib/utils'
SiteController = require 'controllers/base/site_controller'
Column = require 'models/column'
UserStory = require 'models/user_story'
BoardView = require 'views/board/board'
ColumnView = require 'views/board/column'

module.exports = class BoardController extends SiteController
  index: (colValue) ->
    @whenProjectIsLoaded().then =>
      @updateTitle app.session.getProjectName()

      @renderReactComponent(BoardView,
        region: 'main'
        visibleColumn: colValue
        boardField: app.session.get('boardField')
        boardColumns: app.session.getBoardColumns()
        project: app.session.get('project')
        iteration: app.session.get('iteration')
        iterations: app.session.get('iterations')
        user: if app.session.isSelfMode() then app.session.get('user')
      ).then (view) =>
        @listenTo(view, 'columnzoom', @_onColumnZoom)
        @listenTo(view, 'modelselected', @_onCardClick)

  _onColumnZoom: (col) ->
    @updateUrl "board/#{col.get('value')}"

  _onCardClick: (view, model) ->
    @redirectTo utils.getDetailHash(model)
