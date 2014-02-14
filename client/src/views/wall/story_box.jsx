/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  	
  return ReactView.createBackboneClass({
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