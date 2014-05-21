/** @jsx React.DOM */
var React = require('react');
var moment = require('moment');
var app = require('application');
var ReactView = require('views/base/react_view');

module.exports = ReactView.createBackboneClass({
  getDefaultProps: function() {
    return {
      cls: ''
    };
  },
  render: function() {
    return (
      <div className="meter-container">
        <div className="bar">
          <div className={ "meter " + this.props.cls} style={{ width: Math.min(100, this.props.percentage) + "%" }}></div>
          <div className="percent">{ this.props.label }</div>
        </div>
      </div>
    );
  }
});
