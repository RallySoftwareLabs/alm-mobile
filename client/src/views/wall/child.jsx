/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  		Grandchild = require ('views/wall/grandchild');
  	
  return ReactView.createChaplinClass({
    render: function() {
        return (  
          <div className={this.getChildClass()}>
               <div className="header">
                    <span className="formattedID">{this.props.formattedID}</span><br />
                    {this.props.children}
               </div>
               <Grandchild status="on" />
               <Grandchild status="on" />
               <Grandchild status="on" />
               <Grandchild />
               <Grandchild />
               <Grandchild />
               <Grandchild />
               <Grandchild />
          </div>
      );
    },
    getChildClass: function() {
      return (this.props.status == "on") ? "child on" : "child";
    }
  });
});