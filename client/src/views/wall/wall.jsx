/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var Flipchart = require ('views/wall/flipchart');
var StoryBox = require ('views/wall/story_box');
var DeviceLoginTip = require ('views/wall/device_login_tip');

module.exports = ReactView.createBackboneClass({
  render: function() {
    var model = this.props.model;
    var flipchartNodes = model.map(function(initiative) {
      return <Flipchart model={initiative}></Flipchart>;     
    });
    if (model.synced && model.isEmpty()) {
      flipchartNodes = <div className="alert alert-warning"><strong>Oh noes!</strong> There are no initiatives for this project.</div>;
    }
    return (  
      <div className="wall"> 
        <div className="col-md-9">
          <h1>Which items are in the plan?</h1>
          <p><StoryBox />Unscheduled Stories <StoryBox planStatus="scheduled" />Stories scheduled in an Iteration or Release <StoryBox planStatus="completed" />Accepted Stories</p>
        </div>
        <DeviceLoginTip />
        <div className="itemList col-md-12">
          {flipchartNodes}
        </div>
      </div>
    );
   },
   generateMobileURL: function() {
      var port = (location.port != "80") ? ":" + location.port : "";
      return location.hostname + port;
   }
});
