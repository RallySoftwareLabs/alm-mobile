_ = require 'underscore'
Fluxxor = require 'fluxxor'
app = require 'application'
appConfig = require 'app_config'
utils = require 'lib/utils'
SiteController = require 'controllers/base/site_controller'
BoardActions = require 'actions/board_actions'
BoardStore = require 'stores/board_store'
BoardView = require 'views/board/board'
RealtimeUpdater = require 'lib/realtime_updater'

module.exports = class BoardController extends SiteController
  index: (colValue) ->
    @whenProjectIsLoaded().then =>
      app.session.getBoardColumns()
    .then (boardColumns) =>
      session = app.session
      @updateTitle session.getProjectName()

      boardStore = @_buildStore(session, boardColumns, )
      
      flux = new Fluxxor.Flux({ BoardStore: boardStore }, BoardActions)
      boardStore.load()
      @renderReactComponent(BoardView,
        region: 'main'
        visibleColumn: colValue
        flux: flux
      ).then (view) =>
        @listenTo(view, 'columnzoom', @_onColumnZoom)
        @listenTo(view, 'modelselected', @_onModelSelected)
        @listenTo(view, 'addnew', @_onAddNew)
        @listenTo(view, 'iterationchange', @_onIterationChanged)
    .then =>
      if appConfig.isProd()
        RealtimeUpdater.listenForRealtimeUpdates({ project: app.session.get('project') })

  _onColumnZoom: (column) ->
    @updateUrl "board/#{column}"

  _onModelSelected: (view, model) ->
    @redirectTo utils.getDetailHash(model)

  _onAddNew: (view, column) ->
    @redirectTo('board/' + column + '/userstory/new')

  _onIterationChanged: (view, iteration) ->
    app.session.set('iteration', iteration)

  _buildStore: (session, boardColumns) ->
    new BoardStore({
      boardField: session.getBoardField()
      boardColumns: boardColumns
      project: session.get('project')
      iteration: session.get('iteration')
      iterations: session.get('iterations')
      user: if session.isSelfMode() then session.get('user')
    })
