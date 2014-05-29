_ = require 'underscore'
Fluxxor = require 'fluxxor'
app = require 'application'
utils = require 'lib/utils'
RegionController = require 'controllers/base/region_controller'
BoardActions = require 'actions/board_actions'
BoardStore = require 'stores/board_store'
BoardView = require 'views/board/board'
DashboardView = require 'views/dashboard'

module.exports = class DoubleBoardController extends RegionController
  view: DashboardView

  index: (colValue) ->
    @whenProjectIsLoaded().then =>
      session = app.session
      @updateTitle session.getProjectName()

      @renderReactComponents([
        _.extend(region: 'main', @_buildBoardApp(@_buildScheduleStateStore(session), colValue)),
        _.extend(region: 'app2', @_buildBoardApp(@_buildKanbanStateStore(session), colValue))
      ]).then (views) =>
        _.each ['main', 'app2'], (region) =>
          @listenTo(views[region], 'modelselected', @_onCardClick)

  _onCardClick: (view, model) ->
    @redirectTo utils.getDetailHash(model)

  _buildScheduleStateStore: (session, colValue) ->
    new BoardStore({
      boardField: 'ScheduleState'
      boardColumns: session.getBoardColumns('ScheduleState')
      project: session.get('project')
      iteration: session.get('iteration')
      iterations: session.get('iterations')
      user: if session.isSelfMode() then session.get('user')
    })

  _buildKanbanStateStore: (session) ->
    new BoardStore({
      boardField: 'c_KanbanState'
      boardColumns: session.getBoardColumns('c_KanbanState')
      project: session.get('project')
      iteration: session.get('iteration')
      iterations: session.get('iterations')
      user: if session.isSelfMode() then session.get('user')
    })

  _buildBoardApp: (boardStore, colValue) ->
    flux = new Fluxxor.Flux({ BoardStore: boardStore }, BoardActions)
    boardStore.load()
    {
      view: BoardView
      props:
        visibleColumn: colValue
        flux: flux
    }