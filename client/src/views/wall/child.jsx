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
               <div className="grandchildren">
                  {this.getFakeGrandchildren()}
               </div>
          </div>
      );
    },
    getChildClass: function() {
      return (this.props.status == "on") ? "child on" : "child";
    },
    getFakeGrandchildren: function() {
      if (this.props.status == "on") { 
        return (
          <div> 
            <Grandchild status="on" />
            <Grandchild status="on" />
            <Grandchild status="on" />
            <Grandchild status="on" />
            <Grandchild status="on" />
            <Grandchild status="on" />
          </div>
        );
      } else {
        return (
          <div>
            <Grandchild status="on" />
            <Grandchild status="on" />
            <Grandchild />
            <Grandchild />
            <Grandchild />
            <Grandchild />
            <Grandchild />
            <Grandchild status="on" />
            <Grandchild />
            <Grandchild />
            <Grandchild status="on" />
          </div>
        );
      }
    }
  });
});