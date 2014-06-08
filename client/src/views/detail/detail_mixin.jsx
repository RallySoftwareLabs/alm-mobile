/** @jsx React.DOM */
var React = require('react');
var app = require('application');
var Toggle = require('views/field/toggle');

module.exports = {
  componentDidMount: function() {
    this.subscribeEvent('startEdit', this.onStartEdit);
  },
  onStartEdit: function(view, field) {
    view.setState({ editMode: true });
  },
  onSave: function() {
    this.publishEvent('save', this, this.props.model);
  },
  onCancel: function() {
    this.publishEvent('cancel', this);
  },
  showError: function(model, resp) {
    respObj = resp.responseJSON;
    if (!respObj) return;

    var errors = (respObj.CreateResult || respObj.OperationResult || {}).Errors;
    this.publishEvent('showerrors', errors);
  },

  getButtonsMarkup: function() {
    return (
      <div className="row">
        <div className="col-xs-1"/>
        <div className="col-xs-5 display save">
          <button className="btn btn-lg btn-primary" onClick={ this.onSave }>Save</button>
        </div>
        <div className="col-xs-5 display cancel">
          <button className="btn btn-lg btn-default" onClick={ this.onCancel }>Cancel</button>
        </div>
        <div className="col-xs-1"/>
      </div>
    );
  },

  getTogglesMarkup: function() {
    return (
      <div className="row">
        <div className="col-xs-1"/>
        <div className="col-xs-5 toggle BlockedView">
          <Toggle item={ this.props.model } editMode={ this.props.newArtifact } field='Blocked' label='Blocked'/>
        </div>
        <div className="col-xs-5 toggle ReadyView">
          <Toggle item={ this.props.model } editMode={ this.props.newArtifact } field='Ready' label='Ready'/>
        </div>
        <div className="col-xs-1"/>
      </div>
    );
  },

  getScheduleStateLabel: function() {
    return (this.getBoardField() == 'ScheduleState') ? 'Schedule State' : 'Kanban State';
  },

  getBoardField: function() {
    return app.session.getBoardField();
  }
};
