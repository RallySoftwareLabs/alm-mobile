/** @jsx React.DOM */
var _ = require('underscore');
var React = require('react');
var Fluxxor = require("fluxxor");
var app = require('application');
var ReactView = require('views/base/react_view');
var UserStory = require('models/user_story');

module.exports = ReactView.createBackboneClass({
  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin("SettingsStore")],

  // Required by StoreWatchMixin
  getStateFromFlux: function() {
    return {
      settingsState: this.getFlux().store("SettingsStore").getState()
    };
  },
  render: function() {
    return (
      <div className="board-settings">
        <h4 className="text-center">Choose columns to display</h4>
        <dl className="dl-horizontal">
            <dt>Field:</dt>
            <dd>{ UserStory.getFieldDisplayName(this.state.settingsState.boardField) }</dd>
            <dt>Project:</dt>
            <dd>{ this.state.settingsState.project.get('_refObjectName') }</dd>
        </dl>
        <div className="row board-columns">
            <div className="col-xs-12 listing">
                <ul className="list-group">{ this._getColumnsMarkup() }</ul>
            </div>
        </div>
      </div>
    );
  },

  _getColumnsMarkup: function() {
    return _.map(this._getColumns(), function(column) {
      return (
        <li className="list-group-item"
            key={ "column " + column.StringValue }
            onClick={ this.onColumnClickFn(column) }
            onKeyDown={ this.handleEnterAsClick(this.onColumnClickFn(column)) }
            tabIndex="0">
            <div className="row board-column">
                <div className="col-xs-1 selection-icon">
                  { column.showing ? <i className="picto icon-ok"/> : <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/> }
                </div>
                <div className="col-xs-11">{ column.StringValue }</div>
            </div>
        </li>
      );
    }, this);
  },

  onColumnClickFn: function(col) {
    return _.bind(function(event) {
      app.aggregator.recordAction({component: this, description: "toggled column"});
      this.getFlux().actions.toggleBoardColumn(col.StringValue);
    }, this);
  },

  _getColumns: function() {
    var boardField = this.state.settingsState.boardField;
    var shownColumns = this.state.settingsState.boardColumns;

    return _.map(this.state.settingsState.allColumns, function(col) {
      return {
        StringValue: col.StringValue,
        showing: _.contains(shownColumns, col.StringValue)
      };
    });
  }
});
