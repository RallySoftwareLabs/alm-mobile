/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view');
  	
  return ReactView.createBackboneClass({
    render: function() {
      return <div className={this.getClass()} />;
    },
    getClass: function() {
      var planStatusStyle = "";
      if (this.props.model != null) {
        planStatusStyle = this.props.model.planStatus();
      }
      if (this.props.planStatus != null) {
        planStatusStyle = this.props.planStatus;
      }
      return "storyBox " + planStatusStyle; 
    }
  });
});