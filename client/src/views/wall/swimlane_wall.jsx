/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var Swimlane = require ('views/wall/swimlane');
var DeviceLoginTip = require ('views/wall/device_login_tip');
  
module.exports = ReactView.createBackboneClass({
  render: function() {
    var swimlanes = this.props.model.map(function(project) {
      return <Swimlane model={project} key={project.get('_refObjectUUID')} />;
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
      </div>
    );
  }
});
