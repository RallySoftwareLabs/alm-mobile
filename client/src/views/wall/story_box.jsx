/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view');
  	
  return ReactView.createBackboneClass({
    render: function() {
      return <div className={this.getClass()} />;
    },
    getClass: function() {
      if (this.props.model != null) {
        if (this.props.model.isScheduled()) {
          return "grandchild on";
        } 
      } else {
        if (this.props.mode == "scheduled") {
          return "grandchild on";
        }
      }
      return "grandchild"; 
    }
  });
});