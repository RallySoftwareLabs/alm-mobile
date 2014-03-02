/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		Flipchart = require ('views/wall/flipchart');
      StoryBox = require ('views/wall/story_box');

  	
  return ReactView.createBackboneClass({
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
            <h1>What is getting planned?</h1>
            <p><StoryBox />Stories not scheduled <StoryBox mode="scheduled" />Stories scheduled in an Iteration or Release</p>
          </div>
          
          <div className="col-md-3 hidden-xs hidden-sm">
            <h4><span aria-hidden="true" class="picto icon-rss"></span>{location.hostname}:{location.port}</h4>
            Access details on your device
          </div>

          <div className="itemList col-md-12">
            {flipchartNodes}
          </div>
        </div>
      );
     }
  });
});