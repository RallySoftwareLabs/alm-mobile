/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),   
      PlanStatusMixin = require ('lib/plan_status_mixin');
    
  return ReactView.createBackboneClass({
    mixins: [PlanStatusMixin],
    render: function() {
      return <div className={'storyBox ' + this.planStatus(this.props.model)} />;
    }
  });
});