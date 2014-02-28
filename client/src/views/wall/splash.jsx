/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      _ = require('underscore'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      app = require('application'),
      PortfolioItem = require('models/portfolio_item');

  return ReactView.createBackboneClass({

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
                <div className="pull-right btn-container">
                  <button className="btn btn-primary" onClick={ this.showCreateWall }>Create a new wall</button>
                </div>
              </div>
            </div>
            <div className="list-group">{ this._getWallProjects() }</div>

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
});