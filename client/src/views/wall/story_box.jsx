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
      if (this.props.model.isScheduled()) {
        return "grandchild on";
      } else {
        return "grandchild"; 
      }
    }
  });
});