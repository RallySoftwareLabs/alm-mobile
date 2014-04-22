/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var app = require('application');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var ColumnView = require('views/board/column');
var IterationHeader = require('views/iteration_header');

module.exports = ReactView.createBackboneClass({
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
          });
      return <div className={"column-cell"} id={"col-" + utils.toCssClass(colValue)} key={ colValue }>{colView}</div>;
    }, this);
    if (!this.props.columns.length) {
      colMarkup = (
        <div className="row">
          <div className="col-xs-offset-2 col-xs-8 well no-columns">
            <p>Your board for this project does not have any columns.</p>
            <p>Click the <a href="/settings" tabIndex="0"><i className="icon-cog"/></a> icon to configure your board.</p>
          </div>
        </div>
      );
    }
    return colMarkup;
  }
});
