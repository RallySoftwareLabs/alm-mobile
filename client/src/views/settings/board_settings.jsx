/** @jsx React.DOM */
define(function() {
  var _ = require('underscore'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      app = require('application'),
      UserStory = require('models/user_story');

  return ReactView.createBackboneClass({

    render: function() {
    	return (
        <div className="board-settings">
          <h4 className="text-center">Choose columns to display</h4>
          <dl className="dl-horizontal">
              <dt>Field:</dt>
              <dd>{ this.props.fieldName }</dd>
              <dt>Project:</dt>
              <dd>{ this.props.model.getProjectName() }</dd>
          </dl>
          <div className="row board-columns">
              <div className="col-xs-12 listing">
                  <div className="list-group">{ this._getColumnsMarkup() }</div>
              </div>
          </div>
        </div>
      );
    },

    _getColumnsMarkup: function() {
      return _.map(this._getColumns(), function(column) {
        return (
          <div className="list-group-item" key={ "column " + column.StringValue }>
              <div className="row board-column" onClick={ this.onColumnClickFn(column) }>
                  <div className="col-xs-1 selection-icon">
                    { column.showing ? <i className="picto icon-ok"/> : <span dangerouslySetInnerHTML={{__html: '&nbsp;'}}/> }
                  </div>
                  <div className="col-xs-11">{ column.StringValue }</div>
              </div>
          </div>
        );
      }, this);
    },

    onColumnClickFn: function(col) {
      return _.bind(function(event) {
        app.aggregator.recordAction({component: this, description: "toggled column"});
        this.publishEvent('columnClick', col.StringValue);
      }, this);
    },

    _getColumns: function() {
      var boardField = this.props.model.get('boardField');
      var shownColumns = this.props.model.getBoardColumns();
      var allColumns = UserStory.getAllowedValues(boardField);

      return _.map(allColumns, function(col) {
        return {
          StringValue: col.StringValue,
          showing: _.contains(shownColumns, col.StringValue)
        };
      });
    }
  });
});