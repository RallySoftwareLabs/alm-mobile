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
      var projects = this.props.model.map(function(project) {
            return <option key={ project.get('_ref') } value={ project.get('_ref') }>{ project.get('_refObjectName') }</option>;
          });
    	return (
        <div>
          <div className="container">
            <h1>Create a new wall</h1>
            <form className="settings" role="form">
              <div className="form-group project">
                <label htmlFor="project" className="control-label choose-project">Where are your initiatives?</label>
                <select name="project" className="form-control project-select" onChange={ this._updateSelectedProject }>{ projects }</select>
              </div>
              { this._getStateSectionMarkup() }
            </form>
          </div>
        </div>
      );
    },

    _getStateSectionMarkup: function() {
      var currentProject = this.state.project;
      if (currentProject) {
        return (
          <div>
            <h3>Which ones should we show?</h3>
            <div className="form-group states listing">
              <div className="list-group">{ this._getStateItems(currentProject) }</div>
            </div>
            <div className="logout">
              <button className="btn btn-primary" onClick={ this._onSave }>Save</button>
            </div>
          </div>
        );
      } else {
        return <div/>;
      }
    },

    _getStateItems: function(currentProject) {
      var allowedValues = PortfolioItem.getAllowedValues('State');
      return _.map(allowedValues, function(allowedValue) {
        return (
          <div className={ "list-group-item " + allowedValue.StringValue } key={ "allowedValue " + allowedValue.StringValue } onClick={ this._selectState(allowedValue) }>
            <div className="row">
              <div className="col-xs-1 selection-icon">{ this._showSelectedWhen(_.has(this.state.states, allowedValue.StringValue)) }</div>
              <div className="col-xs-11">{ allowedValue.StringValue }</div>
            </div>
          </div>
        );
      }, this);
    },

    _updateSelectedProject: function(event) {
      var me = this;
      var project = this.props.model.find(_.isAttributeEqual('_ref', this.$('.project-select option:selected').val()));
      app.aggregator.recordAction({component: this, description: "selected wall project"});
      app.session.loadSchema(project).then(function(schema) {
        me.setState({
          project: project,
          states: {}
        });
      });
    },

    _selectState: function(allowedValue) {
      app.aggregator.recordAction({component: this, description: "selected wall state"});
    },

    _showSelectedWhen: function(bool) {
      if (bool) {
        return <i className="picto icon-ok"/>;
      }
      return <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>;
    },

    _onSave: function() {
      this.publishEvent('createwall', this.state.project)
    }
  });
});