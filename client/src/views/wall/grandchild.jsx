/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  	
  return ReactView.createChaplinClass({
    render: function() {

      //This is so wrong, both from a less perspective and with React. 
      var style;
      if (this.props.status == "on") {
        style = "grandchild-on";
      } else {
        style = "grandchild";
      }
      return (
        <div className={style} />      
      );
     }
  });
});