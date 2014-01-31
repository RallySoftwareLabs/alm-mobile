/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  		Grandchild = require ('views/wall/grandchild');
  	
  return ReactView.createChaplinClass({
    render: function() {
         //This is so wrong, both from a less perspective and with React. And copy/paste with grandchild.
        var style;
        if (this.props.status == "on") {
          style = "child-on";
        } else {
          style = "child";
        }
        return (  
          <div className={style}>
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
     }
  });
});