/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		Swimlane = require ('views/wall/swimlane');
  	
  return ReactView.createBackboneClass({
    render: function() {
      var swimlanes = this.props.model.map(function(project) {
        return <Swimlane model={project} />;     
      });
      return (  
        <div className="wall"> 
          <h1>How much planning is done?</h1>
          <div className="swimlaneList">
            {swimlanes}
          </div>
        </div>
      );
     }
  });
});