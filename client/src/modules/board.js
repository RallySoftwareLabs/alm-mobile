var app = require('application');
var MetricsHandler = require('lib/metrics_handler');
var BoardActions = require('actions/board_actions');
var BoardStore = require('stores/board_store');
var BoardView = require('views/board/board');
var Project = require('models/project');
var Iterations = require('collections/iterations');
require('backbone_mods');

module.exports = {
  store: BoardStore,
  view: BoardView,
  actions: BoardActions,
  Project: Project,
  Iterations: Iterations,
  app: app,
  metricsHandler: MetricsHandler
}
