_ = require 'underscore'
app = require 'application'
utils = require 'lib/utils'
RegionController = require 'controllers/base/region_controller'
Column = require 'models/column'
UserStory = require 'models/user_story'
BoardView = require 'views/board/board'
ColumnView = require 'views/board/column'
DashboardView = require 'views/dashboard'

module.exports = class DoubleBoardController extends RegionController
  view: DashboardView

  index: (colValue) ->
    @whenProjectIsLoaded().then =>
      @updateTitle app.session.getProjectName()

      @renderReactComponents([{
        view: BoardView
        region: 'main'
        props:
          visibleColumn: colValue
          boardField: 'ScheduleState'
          boardColumns: app.session.getBoardColumns('ScheduleState')
          project: app.session.get('project')
          iteration: app.session.get('iteration')
      }, {
        view: BoardView
        region: 'app2'
        props:
          visibleColumn: colValue
          boardField: 'c_KanbanState'
          boardColumns: app.session.getBoardColumns('c_KanbanState')
          project: app.session.get('project')
          iteration: app.session.get('iteration')
      }]).then (views) =>
        _.each ['main', 'app2'], (region) =>
          @listenTo(views[region], 'columnzoom', @_onColumnZoom)
          @listenTo(views[region], 'modelselected', @_onCardClick)

  _onCardClick: (view, model) ->
    @redirectTo utils.getDetailHash(model)
