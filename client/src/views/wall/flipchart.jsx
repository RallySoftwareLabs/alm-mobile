/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		Child = require ('views/wall/child');
  	
  return ReactView.createChaplinClass({
    render: function() {
      return (
        <div className="flipchart">
             <div className="header">
                  <span className="formattedID">{this.props.formattedID}</span><br />
                  <span className="title">{this.props.children}</span><br />
             </div> 
             <Child formattedID="F12">Feature Name here</Child>
             <Child formattedID="F13" status="on">A planned feature</Child>
             <Child formattedID="F14">Feature name here</Child>
             <Child formattedID="F15">Feature name here</Child>
        </div>
      );
     }
  });
});