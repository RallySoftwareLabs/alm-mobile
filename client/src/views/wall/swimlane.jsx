/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		IterationBox = require ('views/wall/iteration_box');
   
  return ReactView.createBackboneClass({
    render: function() {
      var model = this.props.model;
      var iterations = model.iterations;
      if (iterations != null) {
        var iterationBoxes = iterations.map(function(iteration) {
          return <IterationBox model={iteration} />;
        });
      }
      return (
        <div className="swimlane">
          <div className="teamName">{model.get('Name')}</div>
          <div>
            {iterationBoxes}
          </div>
        </div>
      );
    }
  });
});