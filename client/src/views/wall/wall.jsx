/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		Flipchart = require ('views/wall/flipchart');
  	
  return ReactView.createChaplinClass({
    render: function() {
      var flipchartNodes = this.props.flipcharts.map(function (flipchart) {
        return <Flipchart formattedID={flipchart.formattedID}>{flipchart.name}</Flipchart>;
      });
      return (   
        <div className="itemList">
          {flipchartNodes}
        </div>
      );
     }
  });
});