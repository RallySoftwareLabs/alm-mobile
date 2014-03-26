/** @jsx React.DOM */
var $ = require('jquery');
var _ = require('underscore');
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var PortfolioItem = require('models/portfolio_item');

module.exports = ReactView.createBackboneClass({

  getInitialState: function() {
    return {};
  },

  render: function() {
    return (
      <div className="splash">
        <div className="container">
          <div className="row header">
            <div className="col-xs-12">
              <h1 className="pull-left">View a wall</h1>
              <div className="pull-right btn-container hidden-xs hidden-sm">
                <button className="btn btn-primary" onClick={ this.showCreateWall }>Create a new wall</button>
              </div>
            </div>
          </div>
          <p className="lead visible-xs visible-sm">Choose the wall from your meeting to dive into the details.</p>
          <div className="list-group">{ this._getWallProjects() }</div>
          <p className="lead clearfix hidden-xs hidden-sm">Getting together with your team to plan?  Walls are optimized for projectors and mobile devices.  Create one, project it on the wall, and your team can use their mobile devices to see more details.</p>
        </div>
      </div>
    );
  },

  _getWallProjects: function() {
    return this.props.model.map(function(project) {
      return (
        <div className="list-group-item" onClick={ this.selectProjectWallFn(project.get('_ref')) }>
          <div className="row">
            <div className="pull-right chevron"><i className="picto icon-chevron-right"/></div>
            <div className="project-item">{ project.get('Name') }</div>
          </div>
        </div>
      );
    }, this);
  },

  selectProjectWallFn: function(projectRef) {
    return _.bind(function() {
      this.publishEvent('selectProject', projectRef);
    }, this);
  },

  showCreateWall: function() {
    this.publishEvent('showCreateWall');
  }
});
