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
    componentWillMount: function() {
      this.updateTitle(app.session.getProjectName());
    },
    render: function() {
    	return (
    		<div className="board">
    		  <IterationHeader visible={true} />
	    		<div class="column-container">{this.getColumns()}</div>
	    	</div>
  		);
    },
    getColumns: function() {
    	var colMarkup = _.map(this.props.columns, function(col) {
    	  var colValue = col.get('value'),
    	  		colView = ColumnView({
		  	  		model: col,
		  	  		columns: this.props.columns,
		  	  		showFields: false,
		  	  		abbreviateHeader: true,
		  	  		showIteration: false,
		  	  		key: colValue
		  	  	});
	  		this.bubbleEvent(colView, 'headerclick', 'headerclick');
	  		this.bubbleEvent(colView, 'cardclick', 'cardclick');
  	  	return <div className={"column-cell"} id={"col-" + utils.toCssClass(colValue)}>{colView}</div>;
    	}, this);
    	if (!this.props.columns.length) {
    		colMarkup = (
    			<div class="row">
    				<div class="col-xs-offset-2 col-xs-8 well no-columns">
    					<p>Your board for this project does not have any columns.</p>
    					<p>Click the <a href="/settings"><i class="icon-cog"/></a> icon to configure your board.</p>
    				</div>
    			</div>
  			);
    	}
    	return colMarkup;
    }
  });
});