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
  },

  load: function() {
    var me = this;
    this.artifacts = new Artifacts();
    this.artifacts.clientMetricsParent = this;

    return this._fetchCards().then(function() {
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

  getIteration: function() { return this.iteration; },

  getIterations: function() { return this.iterations; },

  setIteration: function(iteration) {
    this.iteration = iteration;
    this.artifacts.reset();
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
    return this.artifacts.fetch(this._getFetchData(this.boardColumns)).then(function() {
      me.artifacts.each(function(artifact) {
        var column = _.find(me.columns, _.isAttributeEqual('value', artifact.get(me.boardField)));
        column.artifacts.add(artifact);
      }, this);
      _.invoke(me.columns, 'trigger', 'sync');
      me.trigger('change');
    });
  },

  _getFetchData: function(values) {
    var colQuery = utils.createQueryFromCollection(values, this.boardField, 'OR', function(value) {
      return '"' + value + '"';
    });
    data = {
      fetch: this.boardField + ',FormattedID,DisplayColor,Blocked,Ready,Name,Owner,PlanEstimate,Tasks:summary[State;Estimate;ToDo;Owner;Blocked],TaskStatus,Defects:summary[State;Owner],DefectStatus,Discussion:summary',
      query: '(' + colQuery + ' AND ((Requirement = null) OR (DirectChildrenCount = 0)))',
      types: 'hierarchicalrequirement,defect',
      order: "Rank ASC",
      pagesize: 100,
      project: this.project.get('_ref'),
      projectScopeUp: false,
      projectScopeDown: true
    };
    if (this.user) {
      data.query = '(' + data.query + ' AND (Owner = "' + this.user.get('_ref') + '"))';
    }
    var iterationRef = this.iteration && this.iteration.get('_ref');
    if (iterationRef) {
      data.query = '(' + data.query + ' AND (Iteration = "' + iterationRef + '"))';
    }

    return { data: data };
  }
});

module.exports = BoardStore;