/** @jsx React.DOM */
var _ = require('underscore');
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var utils = require('lib/utils');

module.exports = ReactView.createBackboneClass({
  render: function() {
    var m = this.props.model;
    var taskCount = this._getTaskCount();
    var tasksMarkup, percentageMarkup, percentage, taskStatus, toDoUnit;

    if (taskCount > 0) {
      percentage = this._getCompletedTaskPercentage();
      taskStatus = this._getTaskStatus();
      
      if (percentage !== 100) {
        percentageMarkup = <div className="percentage">{ percentage }%</div>;
      }
      
      toDo = this._getToDo();
      if (this._hasTaskEstimate() && toDo > 0) {
        tasksMarkup = (
          <span>
            <div className="status-icon to-do"></div>
            <div className="to-do-value">{ toDo }{ this._getToDoUnit() }</div>
          </span>
        );
      }
      return (
        <div className="status-value tasks"
             title="Manage Tasks"
             onClick={ this._onClick }
             role="link"
             aria-label={ "This item has " + taskCount + " tasks. Click to view or edit them." }>
            <div className={ "status-icon " + taskStatus }></div>
            { percentageMarkup }
            { tasksMarkup }
        </div>
      );
    }
    return <div/>;
  },

  _onClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked card tasks'});
    this.routeTo(utils.getDetailHash(this.props.model) + '/tasks');
    e.preventDefault();
  },

  _getTaskCount: function() {
    var summary = this.props.model.get('Summary');
    return (summary && summary.Tasks && summary.Tasks.Count) || 0;
  },

  _getCompletedTaskPercentage: function() {
    var tasksSummary = this.props.model.get('Summary').Tasks;
    var completedTaskCount = tasksSummary.State.Completed || 0;
    return _.parseInt((completedTaskCount/tasksSummary.Count) * 100);
  },

  _hasTaskEstimate: function(){
    return _.any(this.props.model.get('Summary').Tasks.Estimate, function(value, key) {
      return (key !== '-- No Entry --');
    });
  },

  _getTaskStatus: function() {
    if (this.props.model.get('TaskStatus')) {
      return this.props.model.get('TaskStatus');
    }

    return this._calculateTaskStatus();
  },

  _calculateTaskStatus: function() {
    var taskSummary = this.props.model.get('Summary').Tasks;
    var hasBlocked = false;
    var allCompleted = true;
    var allDefined = true;

    if (taskSummary.Blocked && taskSummary.Blocked["true"] > 0) {
      hasBlocked = true;
    }
    if (!taskSummary.State.Completed || taskSummary.State.Completed < taskSummary.Count) {
      allCompleted = false;
    }
    if (!taskSummary.State.Defined || taskSummary.State.Defined < taskSummary.Count) {
      allDefined = false;
    }

    if (allCompleted && hasBlocked) {
      return "COMPLETED_BLOCKED";
    }

    if (allCompleted) {
      return "COMPLETED";
    }

    if (hasBlocked) {
      return "IN_PROGRESS_BLOCKED";
    }

    if (allDefined) {
      return "DEFINED";
    }

    return "IN_PROGRESS";
  },

  _getToDo: function(){
    var toDo = 0;
    _.each(this.props.model.get('Summary').Tasks.ToDo, function(val, key){
      if (key !== this.nullAttr) {
        toDo += parseFloat(key.replace(/[^\d]+$/, '')) * val;
      }
    }, this);
    return _.parseInt(toDo);
  },

  _getToDoUnit: function() {
    return app.session.get('user').get('UserProfile').DefaultWorkspace.WorkspaceConfiguration.TaskUnitName.charAt(0).toLowerCase();
  }
});
