/** @jsx React.DOM */
var $ = require('jquery');
var _ = require('underscore');
var React = require('react');
var app = require('application');
var ReactView = require('views/base/react_view');
var HeaderView = require('views/header');
var NavigationView = require('views/navigation/navigation');
var ErrorDialog = require('views/error_dialog');

module.exports = ReactView.createBackboneClass({
  render: function() {
    return (
      <div className="site">
        <div className="header-container" id="header">
          <HeaderView/>
        </div>

        <div className="navigation-container page left" id="navigation">
          <NavigationView/>
        </div>

        <div className="page-container page transition center" id="page-container">
          <div className="content-container" id="content">{ this._getContent() }</div>
        </div>
        <ErrorDialog/>
        <div id="mask" style={ {display: "none"} }/>
        { this._getBottomNavBar() }
      </div>
    );
  },

  _getContent: function() {
    return this.props.main.view(this.props.main.props);
  },

  _getBottomNavBar: function() {
    if (this.props.bottom) {
      return this.props.bottom.view(this.props.bottom.props);
    }
  }
});
