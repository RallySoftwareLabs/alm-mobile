/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  	
  return ReactView.createChaplinClass({
    render: function() {
      return (
        <div className={this.getClass()} />      
      );
    },
    getClass: function() {      
      return (this.props.status == "on") ? "grandchild on" : "grandchild";
    }
  });
});