/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		Flipchart = require ('views/wall/flipchart');
  	
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