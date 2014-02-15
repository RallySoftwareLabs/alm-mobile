/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		Flipchart = require ('views/wall/flipchart');
  	
  return ReactView.createBackboneClass({
    render: function() {
      var flipchartNodes = this.props.model.map(function(initiative) {
        return <Flipchart model={initiative}></Flipchart>;     
      });
      return (  
        <div className="wall"> 
          <h1>
            Which items have been planned?<br />
            <small>Features and Stories turn blue when scheduled in an iteration or release</small>
          </h1>
          <div className="itemList">
            {flipchartNodes}
          </div>
        </div>
      );
     }
  });
});