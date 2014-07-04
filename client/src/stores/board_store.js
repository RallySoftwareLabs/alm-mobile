var _ = require('underscore');
var Promise = require('es6-promise').Promise;
var Fluxxor = require("fluxxor");
var app = require('application');
var Messageable = require('lib/messageable');
var utils = require('lib/utils');
var Artifacts = require('collections/artifacts');
var Artifact = require('models/artifact');
var Column = require('models/column');
var UserStory = require('models/user_story');

var STORE_TYPES = ['hierarchicalrequirement', 'defect'];

var BoardStore = Fluxxor.createStore({
  clientMetricsType: 'BoardStore',

  initialize: function(options) {
    this.boardField = options.boardField;
    this.boardColumns = options.boardColumns;
    this.project = options.project;
    this.iteration = options.iteration;
    this.iterations = options.iterations;
    this.user = options.user;
    this.artifacts = new Artifacts();
    this.scheduleStates = ['Defined', 'In-Progress', 'Completed', 'Accepted'];

    Messageable.subscribeEvent('realtimeMessage', this._onRealtimeMessage, this);
    this.bindActions('setIteration', this.setIteration);
  },

  getState: function() {
    return {
      boardField: this.boardField,
      boardColumns: this.boardColumns,
      project: this.project,
      iteration: this.iteration,
      iterations: this.iterations,
      user: this.user,
      columns: this.boardColumns,
      scheduleStates: this.scheduleStates,
      artifacts: this.artifacts
    };
  },

  load: function() {
    app.aggregator.beginLoad({ component: this, description: 'load' });
    var me = this;
    return Promise.all([
      // UserStory.getAllowedValues('ScheduleState'),
      this._fetchCards()
    ]).then(function(scheduleStates) {
      // me.scheduleStates = _.pluck(scheduleStates[0], 'StringValue');
      me.emit('change');
      app.aggregator.endLoad({ component: me });
      app.aggregator.recordComponentReady({ component: me });
    });
  },

  setIteration: function(iteration) {
    var me = this;
    this.iteration = iteration;
    this.artifacts.setSynced(false);
    this.artifacts.reset();
    this.emit('change');
    this._fetchCards().then(function() {
      me.emit('change');
    });
  },

  _fetchCards: function() {
    var me = this;
    var fetchPromise;
    var fetchData = this._getFetchData();
    if (this.iteration) {
      fetchPromise = this.iteration.fetchScheduledItems(fetchData);
    } else {
      var artifacts = new Artifacts();
      artifacts.clientMetricsParent = this;
      fetchPromise = artifacts.fetchAllPages({ data: fetchData });
    }
    return fetchPromise.then(function(artifacts) {
      me.artifacts = artifacts;
    });
  },

  _getFetchData: function(additionalQuery) {
    var query, kanbanFieldsQuery;
    var iterationRef = this.iteration && this.iteration.get('_ref');
    if (iterationRef) {
      query = '(Iteration = "' + iterationRef + '")';
    } else {
      kanbanFieldsQuery = utils.createQueryFromCollection(this.boardColumns, this.boardField, 'OR', function(value) {
        return '"' + value + '"';
      });
      kanbanFieldsQuery = kanbanFieldsQuery.replace('(c_KanbanState = "Released")', '((c_KanbanState = "Released") AND (Release = null))');
      query = '(' + kanbanFieldsQuery + ' AND ((Requirement = null) OR (DirectChildrenCount = 0)))';
    }
    data = {
      shallowFetch: this.boardField + ',FormattedID,DisplayColor,Blocked,Ready,Name,Owner,PlanEstimate,ScheduleState,State,Tasks:summary[State;ToDo;Blocked],TaskStatus,Defects:summary[State],DefectStatus,Discussion:summary',
      query: query,
      pagesize: 200,
      types: STORE_TYPES.join(','),
      order: "Rank ASC",
      project: this.project.get('_ref'),
      projectScopeUp: false,
      projectScopeDown: true
    };
    if (this.user) {
      data.query = '(' + data.query + ' AND (Owner = "' + this.user.get('_ref') + '"))';
    }
    if (additionalQuery) {
      data.query = '(' + data.query + ' AND ' + additionalQuery + ')';
    }

    return data;
  },

  _onRealtimeMessage: function(msgData) {
    var me = this;
    var model = this._findModel(msgData);
    var modelType = utils.getWsapiType(msgData.modelType);


    if (msgData.action === 'Recycled') {
      if (model) {
        this.artifacts.remove(model);
        me.emit('change');
      }
      return;
    }

    if (!_.contains(STORE_TYPES, modelType)) {
      return;
    }

    if (msgData.action === 'Created' || !model) {
      model = this._createModelFromRealtimeMessage(msgData);
      this.artifacts.add(model);
    }
    this._updateModelOnPage(model, msgData).then(function() {
      me.emit('change');
    });
  },

  _findModel: function(msgData) {
    var uuid = msgData.id;

    if (!this.artifacts) {
      return null;
    }

    return this.artifacts.find(_.isAttributeEqual('_refObjectUUID', uuid));
  },

  _createModelFromRealtimeMessage: function(msgData) {
    var modelType = utils.getWsapiType(msgData.modelType);
    var artifact = new Artifact({ _refObjectUUID: msgData.id });
    artifact.typePath = modelType;
    return artifact;
  },

  _updateModelOnPage: function(model, msgData, isCreate) {
    var me = this;
    var modelType = utils.getWsapiType(msgData.modelType);
    var artifacts = new Artifacts();
    artifacts.urlRoot = model.urlRoot.replace('artifact', modelType);
    return artifacts.fetch({
      data: this._getFetchData('(ObjectID = ' + msgData.state.ObjectID + ')')
    }).then(function() {
      var artifact = null;
      if (artifacts.length === 1) {
        artifact = artifacts.at(0);
      }
      me.artifacts.remove(model);
      if (artifact) {
        me.artifacts.add(artifact);
      }
    });
  }
});

module.exports = BoardStore;
