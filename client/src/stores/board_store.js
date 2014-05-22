var _ = require('underscore');
var app = require('application');
var utils = require('lib/utils');
var Artifacts = require('collections/artifacts');
var Column = require('models/column');
var UserStory = require('models/user_story');
var BaseStore = require('stores/base_store');

var BoardStore = Object.create(BaseStore);

_.extend(BoardStore, {
  init: function(opts) {
    this.boardField = opts.boardField;
    this.boardColumns = opts.boardColumns;
    this.project = opts.project;
    this.iteration = opts.iteration;
    this.iterations = opts.iterations;
    this.user = opts.user;
    this.visibleColumn = opts.visibleColumn;
    this.columns = this._getColumnModels();
    this.scheduleStates = [];
  },

  load: function() {
    var me = this;
    return Promise.all([
      UserStory.getAllowedValues('ScheduleState'),
      this._fetchCards()
    ]).then(function(scheduleStates) {
      me.scheduleStates = _.pluck(scheduleStates[0], 'StringValue');
      _.invoke(me.columns, 'trigger', 'sync');
      me.trigger('change');
      app.aggregator.recordComponentReady({ component: me });
    });
  },

  getColumns: function() { return this.columns; },

  getVisibleColumns: function() {
    if (this.visibleColumn) {
      return _.filter(this.columns, _.isAttributeEqual('value', this.visibleColumn));
    } else {
      return this.columns;
    }
  },

  showOnlyColumn: function(visibleColumn) {
    this.visibleColumn = visibleColumn;
    this.trigger('change');
  },

  isZoomedIn: function() { return !!this.visibleColumn; },

  getScheduleStates: function() {
    return this.scheduleStates;
  },

  getArtifacts: function() {
    return this.artifacts;
  },

  getIteration: function() { return this.iteration; },

  getIterations: function() { return this.iterations; },

  setIteration: function(iteration) {
    this.iteration = iteration;
    _.each(this.columns, function(col) { col.artifacts.reset(); });
    this.trigger('change');
    this._fetchCards();
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
          column.artifacts.add(artifact);
        }
      }, this);
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