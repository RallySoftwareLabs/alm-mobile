var _ = require('underscore');
var Promise = require('es6-promise').Promise;
var Fluxxor = require("fluxxor");
var app = require('application');
var bus = require('message_bus');
var Messageable = require('lib/messageable');
var RealtimeUpdater = require('lib/realtime_updater');
var utils = require('lib/utils');
var Artifacts = require('collections/artifacts');
var Projects = require('collections/projects');
var Artifact = require('models/artifact');
var Column = require('models/column');
var UserStory = require('models/user_story');

var STORE_TYPES = ['hierarchicalrequirement', 'defect'];

var SettingsStore = Fluxxor.createStore({
  clientMetricsType: 'SettingsStore',

  initialize: function(options) {
    this.session = options.session;
    this.boardColumns = [];
    this.allColumns = [];
    this.projects = [];
    this.bindActions('setMode', this._setMode);
    this.bindActions('setBoardField', this._setBoardField);
    this.bindActions('setProject', this._setProject);
    this.bindActions('setIteration', this._setIteration);
    this.bindActions('toggleBoardColumn', this._toggleBoardColumn);
    bus.on('projectready', this._onProjectReady, this);
  },

  destroy: function() {
    bus.off('projectready', this._onProjectReady, this);
  },

  getState: function() {
    var session = this.session;
    return {
      boardField: session.getBoardField(),
      boardColumns: this.boardColumns,
      project: session.get('project'),
      projects: this.projects,
      iteration: session.get('iteration'),
      iterations: session.get('iterations'),
      mode: session.get('mode'),
      columns: this.boardColumns,
      allColumns: this.allColumns
    };
  },

  load: function() {
    var me = this;
    return Promise.all([
      Projects.fetchAll(),
      me.session.getBoardColumns(),
      UserStory.getAllowedValues(me.session.getBoardField())
    ]).then(function(promises) {
      me.projects = promises[0];
      me.boardColumns = promises[1];
      me.allColumns = promises[2];
      me.emit('change');
      app.aggregator.recordComponentReady({ component: me });
    });
  },

  _setMode: function(mode) {
    this.session.set('mode', mode);
    this.emit('change');
  },

  _setBoardField: function(boardField) {
    var me = this;
    me.session.setBoardField(boardField).then(function() {
      me.emit('change');
    });
  },

  _setProject: function(projectRef) {
    var newProject = this.projects.find(_.isAttributeEqual('_ref', projectRef));
    this.session.set('project', newProject);
    this.emit('change');
  },

  _setIteration: function(iterationRef) {
    var newIteration = null;
    if (iterationRef !== 'null') {
      this.session.get('iterations').find(_.isAttributeEqual('_ref', iterationRef));
    }
    
    this.session.set('iteration', newIteration);
    this.emit('change');
  },

  _toggleBoardColumn: function(column) {
    var me = this;
    me.session.toggleBoardColumn(column).then(function(boardColumns) {
      me.boardColumns = boardColumns;
      me.emit('change');
    });
  },

  _onProjectReady: function() {
    this.emit('change');
  }
});

module.exports = SettingsStore;