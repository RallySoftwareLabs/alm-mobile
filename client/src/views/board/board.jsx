/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var ColumnView = require('views/board/column');
var IterationHeader = require('views/iteration_header');
var StatsBanner = require('views/stats_banner');

module.exports = ReactView.createBackboneClass({
  getInitialState: function() {
    return {
      visibleColumn: this.props.visibleColumn
    };
  },
  componentDidMount: function() {
    this.listenTo(this.props.store, 'change', this.forceUpdate);
  },
  componentWillReceiveProps: function(newProps) {
    this.stopListening(this.props.store, 'change', this.forceUpdate);
    this.listenTo(newProps.store, 'change', this.forceUpdate);
    this.setState({ visibleColumn: newProps.visibleColumn });
  },

  render: function() {
    return (
      <div className="board">
        <IterationHeader visible={true}
                         iteration={ this.props.store.getIteration() }
                         iterations={ this.props.store.getIterations() }
                         onChange={ this._onIterationChange }
                         onSelect={ this._onIterationSelect } />
        { this.getStatsBannerMarkup() }
        <div className="column-container">{this.getColumns()}</div>
      </div>
    );
  },
  getStatsBannerMarkup: function() {
    var columns = this.props.store.getColumns();
    if (this.props.store.getIteration() && columns.length && !this._isZoomedIn()) {
      return <StatsBanner store={ this.props.store }/>;
    }
    return null;
  },
  getColumns: function() {
    var columns = this.props.store.getColumns();
    var visibleColumns = this._getVisibleColumns(columns);
    var zoomedIn = this._isZoomedIn();
    var colMarkup = _.map(visibleColumns, function(col) {
      var colValue = col.get('value');
      var colView = ColumnView({
            model: col,
            columns: columns,
            singleColumn: zoomedIn,
            abbreviateHeader: !zoomedIn,
            showIteration: false,
            onCardClick: this._onCardClick,
            onHeaderClick: this._onColumnClick
          });
      return <div className={"column-cell"} id={"col-" + utils.toCssClass(colValue)} key={ colValue }>{colView}</div>;
    }, this);
    if (!columns.length) {
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
  },

  _getVisibleColumns: function(columns) {
    if (this.state.visibleColumn) {
      return _.filter(columns, _.isAttributeEqual('value', this.state.visibleColumn));
    } else {
      return columns;
    }
  },

  _isZoomedIn: function() {
    return !!this.state.visibleColumn;
  },

  _onColumnClick: function(view, column) {
    var me = this;
    me.setState({ visibleColumn: column.get('value') }, function() {
      me.trigger('columnzoom', column);
    });
  },

  _onCardClick: function(view, model) {
    this.trigger('modelselected', view, model);
  },

  _onIterationChange: function(view, iteration) {
    this.props.store.setIteration(iteration);
  },

  _onIterationSelect: function(view, iteration) {
    this.trigger('modelselected', view, iteration);
  }
});
