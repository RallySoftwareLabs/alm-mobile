/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		ReactView = require('views/base/react_view'),
  		ColumnView = require('views/board/column'),
  		IterationHeader = require('views/iteration_header');

  return ReactView.createChaplinClass({
    render: function() {
    	return (
    		<div className="item">
			  <div className="item_heading"><span className="FormattedID">I129</span><br />Spike and define path towards linear scalability of ALM</div>
			  <div className="child">
			    <div className="heading">
			    <span className="FormattedID">F1</span><br />Share Background Information and Level Set<br /></div>
			    <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild-on"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>  
			  <div className="grandchild"></div>      
			</div>
	      </div>		
  		);
    }
  });
});