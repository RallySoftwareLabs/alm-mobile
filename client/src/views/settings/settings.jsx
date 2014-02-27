/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      _ = require('underscore'),
      React = require('react'),
      ReactView = require('views/base/react_view');

  return ReactView.createBackboneClass({

    render: function() {
      var session = this.props.model,
          currentProject = session.get('project'),
          currentIteration = session.get('iteration'),
          boardField = session.get('boardField'),
          projects = session.get('projects').models.map(function(project) {
            return <option key={ project.get('_ref') } value={ project.get('_ref') }>{ project.get('_refObjectName') }</option>;
          }),
          iterations = session.get('iterations').models.map(function(iteration) {
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
            <div className="form-group scope listing">
              <label className="control-label show-work">Show</label>
              <div className="list-group">{ this._getModeItems() }</div>
            </div>
            <div className="form-group board-column listing">
              <label className="control-label board-field">Board Column</label>
              <div className="list-group">{ this._getBoardFieldItems() }</div>
            </div>
            <div className="logout">
              <button className="btn btn-default" onClick={ this.triggerLogout }>Logout</button>
            </div>
          </form>
        </div>
      );
    },

    _getModeItems: function() {
      var currentMode = this.props.model.get('mode'),
          modes = [{
            mode: 'self',
            text: 'My Work'
          }, {
            mode: 'team',
            text: 'My Team'
          }];
      return _.map(modes, function(mode) {
        return (
          <div className={ "list-group-item " + mode.mode } key={ "mode " + mode.mode } onClick={ this.changeModeFn(mode) }>
            <div className="row">
              <div className="col-xs-1 selection-icon">{ this._showSelectedWhen(currentMode === mode.mode) }</div>
              <div className="col-xs-11">{ mode.text }</div>
            </div>
          </div>
        );
      }, this);
    },

    _getBoardFieldItems: function() {
      var currentField = this.props.model.get('boardField'),
          fields = [{
            field: 'ScheduleState',
            text: 'Schedule State'
          }, {
            field: 'c_KanbanState',
            text: 'Kanban State'
          }];
      return _.map(fields, function(field) {
        return (
          <div className="list-group-item schedule-state" key={ "field " + field.field } onClick={ this.changeBoardFieldFn(field) }>
            <div className="row">
              <div className="col-xs-1 selection-icon">{ this._showSelectedWhen(currentField === field.field) }</div>
              <div className="col-xs-10">{ field.text }</div>
              <div className="col-xs-1 chevron"><i className="picto icon-chevron-right"/></div>
            </div>
          </div>
        );
      }, this);
    },

    _showSelectedWhen: function(bool) {
      if (bool) {
        return <i className="picto icon-ok"/>;
      }
      return <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>;
    },

    triggerLogout: function(event) {
      this.publishEvent('logout');
      event.preventDefault();
    },

    changeModeFn: function(mode) {
      return _.bind(function() {
        var newMode = mode.mode;
        this.publishEvent('changeMode', newMode);
      }, this);
    },

    changeBoardFieldFn: function(field) {
      return _.bind(function() {
        var newField = field.field;
        this.publishEvent('changeBoardField', newField);
      }, this);
    },

    updateSelectedProject: function(event) {
      this.publishEvent('changeProject', this.$('.project-select option:selected').val());
    },

    updateSelectedIteration: function(event) {
      this.publishEvent('changeIteration', this.$('.iteration-select option:selected').val());
    }
  });
});