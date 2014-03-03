/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		Swimlane = require ('views/wall/swimlane'),
      DeviceLoginTip = require ('views/wall/device_login_tip');
  	
  return ReactView.createBackboneClass({
    render: function() {
      var swimlanes = this.props.model.map(function(project) {
        return <Swimlane model={project} />;     
      });
      return (  
        <div className="wall"> 
          <div className="col-md-9">
            <h1>How much planning is done?</h1>
            <p><StoryBox mode="scheduled" />Stories <div className="picto icon-defect"/>Defects</p>
          </div>
          <DeviceLoginTip />
          <div className="swimlaneList col-md-12">
            {swimlanes}
          </div>
        </div>
      );
     }
  });
});