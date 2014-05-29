var _ = require('underscore');
var Fluxxor = require("fluxxor");
var app = require('application');
var utils = require('lib/utils');
var Artifacts = require('collections/artifacts');
var Column = require('models/column');
var UserStory = require('models/user_story');

var BoardStore = Fluxxor.createStore({

  initialize: function(options) {
    this.boardField = options.boardField;
    this.boardColumns = options.boardColumns;
    this.project = options.project;
    this.iteration = options.iteration;
    this.iterations = options.iterations;
    this.user = options.user;
    this.columns = this._getColumnModels();
    this.scheduleStates = [];

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
      columns: this.columns,
      scheduleStates: this.scheduleStates
    };
  },

  load: function() {
    var me = this;
    return Promise.all([
      UserStory.getAllowedValues('ScheduleState'),
      this._fetchCards()
    ]).then(function(scheduleStates) {
      me.scheduleStates = _.pluck(scheduleStates[0], 'StringValue');
      _.invoke(me.columns, 'trigger', 'sync');
      me.emit('change');
      app.aggregator.recordComponentReady({ component: me });
    });
  },

  getColumns: function() {
    return this.columns;
  },

  getScheduleStates: function() {
    return this.scheduleStates;
  },

  getArtifacts: function() {
    return this.artifacts;
  },

  getIteration: function() {
    return this.iteration;
  },

  getIterations: function() {
    return this.iterations;
  },

  setIteration: function(iteration) {
    var me = this;
    this.iteration = iteration;
    _.each(this.columns, function(col) {
      col.setSynced(false);
      col.artifacts.reset();
    });
    this.emit('change');
    this._fetchCards().then(function() {
      me.emit('change');
    });
  },

  _getColumnModels: function() {
    return _.map(this.boardColumns, function(value) {
      var col = new Column({ boardField: this.boardField, value: value });
      col.clientMetricsParent = this;
      return col;
    }, this);
  },

  _fetchCards: function() {
    var me = this;
    var fetchPromise;
    var fetchData = this._getFetchData(this.boardColumns);
    if (this.iteration) {
      fetchPromise = this.iteration.fetchScheduledItems(fetchData);
    } else {
      var artifacts = new Artifacts();
      artifacts.clientMetricsParent = this;
      fetchPromise = artifacts.fetchAllPages({ data: fetchData });
    }
    return fetchPromise.then(function(artifacts) {
      me.artifacts = artifacts;
      artifacts.each(function(artifact) {
        var column = _.find(me.columns, _.isAttributeEqual('value', artifact.get(me.boardField)));
        if (column) {
          column.artifacts.add(artifact, {silent: true});
        }
      }, this);
      _.each(me.columns, function(col) {
        col.setSynced(true);
      });
    });
  },

  _getFetchData: function(values) {
    var query, kanbanFieldsQuery;
    var iterationRef = this.iteration && this.iteration.get('_ref');
    if (iterationRef) {
      query = '(Iteration = "' + iterationRef + '")';
    } else {
      kanbanFieldsQuery = utils.createQueryFromCollection(values, this.boardField, 'OR', function(value) {
        return '"' + value + '"';
      });
      kanbanFieldsQuery = kanbanFieldsQuery.replace('(c_KanbanState = "Released")', '((c_KanbanState = "Released") AND (Release = null))');
      query = '(' + kanbanFieldsQuery + ' AND ((Requirement = null) OR (DirectChildrenCount = 0)))';
    }
    data = {
      shallowFetch: this.boardField + ',FormattedID,DisplayColor,Blocked,Ready,Name,Owner,PlanEstimate,ScheduleState,State,Tasks:summary[State;ToDo;Blocked],TaskStatus,Defects:summary[State],DefectStatus,Discussion:summary',
      query: query,
      pagesize: 200,
      types: 'hierarchicalrequirement,defect',
      order: "Rank ASC",
      project: this.project.get('_ref'),
      projectScopeUp: false,
      projectScopeDown: true
    };
    if (this.user) {
      data.query = '(' + data.query + ' AND (Owner = "' + this.user.get('_ref') + '"))';
    }

    return data;
  }
});

module.exports = BoardStore;