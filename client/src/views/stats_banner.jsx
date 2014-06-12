/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var PlanStatusMixin = require ('lib/plan_status_mixin');
var ProgressMeter = require('views/progress_meter');

module.exports = ReactView.createBackboneClass({
  mixins: [PlanStatusMixin],
  render: function() {
    var iteration = this.props.boardState.iteration;
    var planEstimateTotal = this.planEstimateTotal(iteration);
    var acceptedPoints = this._getAcceptedPoints(iteration.artifacts);
    return (
      <div className="stats-banner">
        <div className="col-xs-3 gauge">
          <h4>Planned Velocity</h4>
          <ProgressMeter percentage={ this.loadPercentage(iteration) }
                         label={ planEstimateTotal + ' of ' + (iteration.get('PlannedVelocity') || '0') + " points" }
                         cls={ this.loadStatus(iteration) }/>
        </div>
        <div className="col-xs-3 gauge">
          <h4>Accepted</h4>
          <ProgressMeter percentage={ acceptedPoints / planEstimateTotal * 100 }
                         label={ acceptedPoints + ' of ' + planEstimateTotal + " points" }
                         cls="responsive"/>
        </div>
        <div className="col-xs-3 gauge">
          <h4>Defects</h4>
          <div className="stat-metric">
            <span className="picto icon-defect"/>
            { this._getActiveDefectCount(iteration) }
            <div className="stat-secondary">active</div>
          </div>
        </div>
        <div className="col-xs-3 gauge">
          <h4>Tasks</h4>
          <div className="stat-metric">
            <span className="picto icon-task"/>
            { this._getActiveTaskCount(iteration) }
            <div className="stat-secondary">active</div>
          </div>
        </div>
      </div>
    );
  },

  _getActiveDefectCount: function(iteration) {
    var activeDefects = 0;
    if (iteration.artifacts) {
      iteration.artifacts.each(function(artifact){
        var defectSummary = artifact.get('Summary') && artifact.get('Summary').Defects;
        if (defectSummary) {
          _.each(defectSummary.State, function(count, state) {
            if (state !== 'Closed') {
              activeDefects += count;
            }
          });
        } else if (artifact.get('_type') === 'Defect' && artifact.get('State') !== 'Closed') {
          activeDefects++;
        }
      });
    }
    return activeDefects;
  },

  _getActiveTaskCount: function(iteration) {
    var taskCount = 0;
    if (iteration.artifacts) {
      iteration.artifacts.each(function(artifact){
        var taskSummary = artifact.get('Summary') && artifact.get('Summary').Tasks;
        if (taskSummary) {
          _.each(taskSummary.State, function(count, state) {
            if (state !== 'Completed') {
              taskCount += count;
            }
          });
        }
      });
    }
    return taskCount;
  },

  _getAcceptedPoints: function(artifacts) {
    var acceptedPoints = 0;
    if (!artifacts) {
      return acceptedPoints;
    }
    var scheduleStates = this.props.boardState.scheduleStates;
    var acceptedStates = _.rest(scheduleStates, _.indexOf(scheduleStates, 'Accepted'));
    artifacts.each(function (artifact) {
        var estimate = artifact.get('PlanEstimate') || 0;
        if (_.contains(acceptedStates, artifact.get('ScheduleState'))) {
            acceptedPoints += estimate;
        }
    });
    return acceptedPoints;
  }
});