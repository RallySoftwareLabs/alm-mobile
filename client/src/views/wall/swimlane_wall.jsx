/** @jsx React.DOM */
<<<<<<< HEAD

var React = require('react');
var ReactView = require('views/base/react_view');
var Swimlane = require ('views/wall/swimlane');
var DeviceLoginTip = require ('views/wall/device_login_tip');
  
module.exports = ReactView.createBackboneClass({
  render: function() {
    var swimlanes = this.props.model.map(function(project) {
      return <Swimlane model={project} />;     
    });
    return (  
      <div className="wall"> 
        <div className="col-md-9">
          <h1>Team Plan</h1>
        </div>
        <DeviceLoginTip />
        <div className="swimlaneList col-md-12">
          {swimlanes}
        </div>
        <nav className="navbar navbar-fixed-bottom navbar-inverse">
          <div className="container nav navbar-nav">
            <div className="navbar-text navbar-left iconLegend"><StoryBox planStatus="scheduled" />Stories <div className="picto icon-defect"/>Defects</div>
            <div className="responsive legendBox">Responsive load<span className="hidden-xs">: All items can be delivered</span><span className="hidden-xs hidden-sm">&nbsp;and the team can respond to changes</span></div>
            <div className="high legendBox">High load<span className="hidden-xs">: Some items may not be delivered</span><span className="hidden-xs hidden-sm">&nbsp;when new information arises</span></div>
            <div className="overloaded legendBox">Overload<span className="hidden-xs">: Some items will not be delivered</span><span className="hidden-xs hidden-sm">&nbsp;since the work exceeds capacity</span></div>
            <div className="unknown legendBox">Load Unknown<span className="hidden-xs">: No velocity set</span><span className="hidden-xs hidden-sm">&nbsp;so the items might not fit</span></div>
          </div>
        </nav>
        <DeviceLoginTip />
        <div className="swimlaneList col-md-12">
          {swimlanes}
        </div>
      </div>
    );
   }
});
