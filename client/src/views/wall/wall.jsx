/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		Flipchart = require ('views/wall/flipchart');
  	
  return ReactView.createChaplinClass({
    render: function() {
      var flipchartNodes = _.map(this.props.model.models, function(initiative) {
        return <Flipchart model={initiative}></Flipchart>;     
      }, this);
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