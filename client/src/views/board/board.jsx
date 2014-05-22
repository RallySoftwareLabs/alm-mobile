/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var utils = require('lib/utils');
var BoardStore = require('stores/board_store');
var ReactView = require('views/base/react_view');
var ColumnView = require('views/board/column');
var IterationHeader = require('views/iteration_header');
var StatsBanner = require('views/stats_banner');

module.exports = ReactView.createBackboneClass({
  getInitialState: function() {
    var store = this._buildStoreFromProps(this.props);
    return {
      store: store
    };
  },
  componentDidMount: function() {
    this.listenTo(this.state.store, 'change', this.forceUpdate);
    this.state.store.load();
  },
  componentWillReceiveProps: function(newProps) {
    var newStore = this._buildStoreFromProps(newProps);
    this.stopListening(this.state.store, 'change', this.forceUpdate);
    this.listenTo(newStore, 'change', this.forceUpdate);
    this.setState({
      store: newStore
    });
    newStore.load();
  },

  render: function() {
    return (
      <div className="board">
        <IterationHeader visible={true}
                         iteration={ this.state.store.getIteration() }
                         iterations={ this.state.store.getIterations() }
                         onChange={ this._onIterationChange }
                         onSelect={ this._onIterationSelect } />
        { this.getStatsBannerMarkup() }
        <div className="column-container">{this.getColumns()}</div>
      </div>
    );
  },
  getStatsBannerMarkup: function() {
    var columns = this.state.store.getColumns();
    if (this.state.store.getIteration() && columns.length && !this.state.store.isZoomedIn()) {
      return <StatsBanner store={ this.state.store }/>;
    }
    return null;
  },
  getColumns: function() {
    var columns = this.state.store.getColumns();
    var visibleColumns = this.state.store.getVisibleColumns();
    var zoomedIn = this.state.store.isZoomedIn();
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

  _buildStoreFromProps: function(props) {
    var store = Object.create(BoardStore);
    store.init({
      boardField: props.boardField,
      boardColumns: props.boardColumns,
      project: props.project,
      iteration: props.iteration,
      iterations: props.iterations,
      user: props.user,
      visibleColumn: props.visibleColumn
    });
    return store;
  },

  _onColumnClick: function(view, column) {
    this.state.store.showOnlyColumn(column.get('value'));
    this.trigger('columnzoom', column);
  },

  _onCardClick: function(view, model) {
    this.trigger('modelselected', view, model);
  },

  _onIterationChange: function(view, iteration) {
    this.state.store.setIteration(iteration);
  },

  _onIterationSelect: function(view, iteration) {
    this.trigger('modelselected', view, iteration);
  }
});
