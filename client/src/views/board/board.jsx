/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		ReactView = require('views/base/react_view'),
  		ColumnView = require('views/board/column'),
  		IterationHeader = require('views/iteration_header');

  return ReactView.createBackboneClass({
    componentWillMount: function() {
      this.updateTitle(app.session.getProjectName());
    },
    render: function() {
    	return (
    		<div className="board">
    		  <IterationHeader visible={true} />
	    		<div className="column-container">{this.getColumns()}</div>
	    	</div>
  		);
    },
    getColumns: function() {
    	var colMarkup = _.map(this.props.columns, function(col, idx) {
    	  var colValue = col.get('value'),
    	  		colView = ColumnView({
		  	  		model: col,
		  	  		columns: this.props.columns,
		  	  		singleColumn: false,
		  	  		abbreviateHeader: true,
		  	  		showIteration: false,
		  	  		key: colValue,
              tabIndex: (idx + 10) * 50
		  	  	});
  	  	return <div className={"column-cell"} id={"col-" + utils.toCssClass(colValue)} key={ colValue }>{colView}</div>;
    	}, this);
    	if (!this.props.columns.length) {
    		colMarkup = (
    			<div className="row">
    				<div className="col-xs-offset-2 col-xs-8 well no-columns">
    					<p>Your board for this project does not have any columns.</p>
    					<p>Click the <a href="/settings" tabIndex="10"><i className="icon-cog"/></a> icon to configure your board.</p>
    				</div>
    			</div>
  			);
    	}
    	return colMarkup;
    }
  });
});