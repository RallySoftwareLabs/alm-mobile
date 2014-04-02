/** @jsx React.DOM */
var $ = require('jquery');
var React = require('react');
var ReactView = require('views/base/react_view');
var StoryBox = require ('views/wall/story_box');
  
module.exports = ReactView.createBackboneClass({
  render: function() {
    return (
      <nav className="navbar navbar-fixed-bottom navbar-inverse">
        <div className="container nav navbar-nav">
          <div className="navbar-text navbar-left iconLegend"><StoryBox planStatus="scheduled" />Stories <div className="picto icon-defect"/>Defects</div>
          <div className="responsive legendBox">Responsive load<span className="hidden-xs">: All items can be delivered</span><span className="hidden-xs hidden-sm"> and the team can respond to changes</span></div>
          <div className="high legendBox">High load<span className="hidden-xs">: Some items may not be delivered</span><span className="hidden-xs hidden-sm"> when new information arises</span></div>
          <div className="overloaded legendBox">Overload<span className="hidden-xs">: Some items will not be delivered</span><span className="hidden-xs hidden-sm"> since the work exceeds capacity</span></div>
          <div className="unknown legendBox">Load Unknown<span className="hidden-xs">: No velocity set</span><span className="hidden-xs hidden-sm"> so the items might not fit</span></div>
        </div>
      </nav>
    );
  },

  componentDidMount: function() {
    $('.swimlaneList').css('padding-bottom', $('.navbar-fixed-bottom').css('height'));
  },

  componentWillUnmount: function() {
    $('.swimlaneList').css('padding-bottom', 0);
  }
});
