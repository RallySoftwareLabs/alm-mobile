/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');   
var PlanStatusMixin = require ('lib/plan_status_mixin');
  
module.exports = ReactView.createBackboneClass({
  mixins: [PlanStatusMixin],
  render: function() {
    return <div className={'storyBox ' + this.planStatus(this.props.model)} />;
  }
});
