  /** @jsx React.DOM */
var _ = require('underscore');
var React = require('react');
var Fluxxor = require("fluxxor");
var app = require('application');
var ReactView = require('views/base/react_view');

module.exports = ReactView.createBackboneClass({
  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin("SettingsStore")],

  // Required by StoreWatchMixin
  getStateFromFlux: function() {
    return {
      settingsState: this.getFlux().store("SettingsStore").getState()
    };
  },
  render: function() {
    var settingsState = this.state.settingsState;
    var currentProject = settingsState.project;
    var currentIteration = settingsState.iteration;
    var boardField = settingsState.boardField;
    var projects = settingsState.projects.map(function(project) {
        return <option key={ project.get('_ref') } value={ project.get('_ref') }>{ project.get('_refObjectName') }</option>;
      });
    var iterations = settingsState.iterations.map(function(iteration) {
      return <option key={ iteration.get('_ref') } value={ iteration.get('_ref') }>{ iteration.get('_refObjectName') }</option>;
    });
  	return (
      <div className="container">
        <form className="settings" role="form">
          <div className="form-group project">
            <label htmlFor="project" className="control-label choose-project">Project</label>
            <select name="project" className="form-control project-select" value={ currentProject.get('_ref') } onChange={ this.updateSelectedProject }>{ projects }</select>
          </div>
          <div className="form-group iteration">
            <label htmlFor="iteration" className="control-label choose-iteration">Iteration</label>
            <select name="iteration" className="form-control iteration-select" value={ currentIteration && currentIteration.get('_ref') || 'null' } onChange={ this.updateSelectedIteration }>
              <option value="null">None</option>
              { iterations }
            </select>
          </div>
          <div className="form-group scope">
            <label className="control-label show-work">Show</label>
            <ul className="list-group">{ this._getModeItems() }</ul>
          </div>
          <div className="form-group board-column">
            <label className="control-label board-field">Board Column</label>
            <ul className="list-group">{ this._getBoardFieldItems(boardField) }</ul>
          </div>
          <div className="logout">
            <button className="btn btn-default" onClick={ this.triggerLogout }>Logout</button>
          </div>
        </form>
      </div>
    );
  },

  _getModeItems: function() {
    var currentMode = this.state.settingsState.mode,
        modes = [{
          mode: 'self',
          text: 'My Work'
        }, {
          mode: 'team',
          text: 'My Team'
        }];
    return _.map(modes, function(mode) {
      return (
        <li className={ "list-group-item " + mode.mode }
            key={ "mode " + mode.mode }
            onClick={ this.changeModeFn(mode) }
            onKeyDown={ this.handleEnterAsClick(this.changeModeFn(mode)) }
            tabIndex="0">
          <div className="row">
            <div className="col-xs-1 selection-icon">{ this._showSelectedWhen(currentMode === mode.mode) }</div>
            <div className="col-xs-11">{ mode.text }</div>
          </div>
        </li>
      );
    }, this);
  },

  _getBoardFieldItems: function(boardField) {
    var fields = [{
      field: 'ScheduleState',
      text: 'Schedule State'
    }, {
      field: 'c_KanbanState',
      text: 'Kanban State'
    }];
    return _.map(fields, function(field) {
      return (
        <li className="list-group-item schedule-state"
            key={ "field " + field.field }
            onClick={ this.changeBoardFieldFn(field) }
            onKeyDown={ this.handleEnterAsClick(this.changeBoardFieldFn(field)) }
            tabIndex="0">
          <div className="row">
            <div className="col-xs-1 selection-icon">{ this._showSelectedWhen(boardField === field.field) }</div>
            <div className="col-xs-10">{ field.text }</div>
            <div className="col-xs-1 chevron"><i className="picto icon-chevron-right"/></div>
          </div>
        </li>
      );
    }, this);
  },

  _showSelectedWhen: function(bool) {
    if (bool) {
      return <i className="picto icon-ok"/>;
    }
    return <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>;
  },

  triggerLogout: function(e) {
    app.aggregator.recordAction({ component: this, description: 'clicked logout button'});
    this.trigger('logout');
    e.preventDefault();
  },

  changeModeFn: function(mode) {
    return _.bind(function() {
      var newMode = mode.mode;
      app.aggregator.recordAction({component: this, description: "changed mode to " + newMode});
      this.getFlux().actions.setMode(newMode);
    }, this);
  },

  changeBoardFieldFn: function(field) {
    return _.bind(function() {
      var newField = field.field;
      app.aggregator.recordAction({component: this, description: "changed board field to " + newField});
      this.getFlux().actions.setBoardField(newField);
      this.trigger('boardFieldChange', this, newField);
    }, this);
  },

  updateSelectedProject: function(e) {
    var project = e.target.value;
    app.aggregator.recordAction({component: this, description: "changed project"});
    this.getFlux().actions.setProject(project);
    this.trigger('changeProject', this, project);
  },

  updateSelectedIteration: function(e) {
    var iteration = e.target.value;
    app.aggregator.recordAction({component: this, description: "changed iteration"});
    this.getFlux().actions.setIteration(iteration);
  }
});
