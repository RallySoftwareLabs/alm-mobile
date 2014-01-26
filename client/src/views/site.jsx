/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      _ = require('underscore'),
      React = require('react'),
      app = require('application'),
  		ReactView = require('views/base/react_view'),
      ErrorDialog = require('views/error_dialog');

  return ReactView.createChaplinClass({
    componentDidMount: function() {
      this.publishEvent('!region:register', this, 'header', '#header');
      this.publishEvent('!region:register', this, 'navigation', '#navigation');
      this.publishEvent('!region:register', this, 'main', '#content');
    },
    componentWillUnmount: function() {
      this.publishEvent('!region:unregister', this, 'header');
      this.publishEvent('!region:unregister', this, 'navigation');
      this.publishEvent('!region:unregister', this, 'main');
    },
    render: function() {
    	return (
        <div>
          <div className="header-container" id="header"/>

          <div className="navigation-container page left" id="navigation"/>

          <div className="page-container page transition center" id="page-container">
              <div className="content-container" id="content"/>
          </div>
          <ErrorDialog/>
          <div id="mask" style={ {display: "none"} }/>
        </div>
      );
    }
  });
});