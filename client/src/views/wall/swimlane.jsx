/** @jsx React.DOM */

var React = require('react');
var ReactView = require('views/base/react_view');
var IterationBox = require ('views/wall/iteration_box');
 
module.exports = ReactView.createBackboneClass({
  render: function() {
    var model = this.props.model;
    var iterations = model.iterations;
    if (iterations != null) {
      var iterationBoxes = iterations.map(function(iteration) {
        return <IterationBox model={iteration} key={iteration.get('_refObjectUUID')} />;
      });
    }
    return (
      <div className="swimlane">
        <div className="teamName col-md-2 col-xs-12">{model.get('Name')}</div>
        <div>
          {iterationBoxes}
        </div>
      </div>
    );
  }
});
