/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var Fluxxor = require("fluxxor");
var app = require('application');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var ColumnView = require('views/board/column');
var IterationHeader = require('views/iteration_header');
var StatsBanner = require('views/stats_banner');

module.exports = ReactView.createBackboneClass({
  mixins: [Fluxxor.FluxMixin(React), Fluxxor.StoreWatchMixin("BoardStore")],

  // Required by StoreWatchMixin
  getStateFromFlux: function() {
    var flux = this.getFlux();
    return {
      boardState: flux.store("BoardStore").getState(),
      visibleColumn: this.props.visibleColumn
    };
  },
  // componentDidMount: function() {
  //   this.listenTo(this.state.boardState, 'change', this.forceUpdate);
  // },
  componentWillReceiveProps: function(newProps) {
    // this.stopListening(this.state.boardState, 'change', this.forceUpdate);
    // this.listenTo(newProps.store, 'change', this.forceUpdate);
    this.setState({ visibleColumn: newProps.visibleColumn });
  },

  render: function() {
    return (
      <div className="board">
        <IterationHeader visible={true}
                         iteration={ this.state.boardState.iteration }
                         iterations={ this.state.boardState.iterations }
                         onChange={ this._onIterationChange }
                         onSelect={ this._onIterationSelect } />
        { this.getStatsBannerMarkup() }
        <button className="btn btn-primary add-button" onClick={this._onAddClick} aria-label="Add new story to this column" tabIndex="0">+ Add</button>
        <div className="column-container">{this.getColumns()}</div>
      </div>
    );
  },
  getStatsBannerMarkup: function() {
    var columns = this.state.boardState.columns;
    if (this.state.boardState.iteration && columns.length && !this._isZoomedIn()) {
      return <StatsBanner boardState={ this.state.boardState }/>;
    }
    return null;
  },
  getColumns: function() {
    var artifacts = this.state.boardState.artifacts;
    var columns = this.state.boardState.columns;
    var visibleColumns = this._getVisibleColumns();
    var zoomedIn = this._isZoomedIn();
    var colMarkup = _.map(visibleColumns, function(col) {
      var colView = ColumnView({
            artifacts: artifacts,
            columns: columns,
            boardField: this.state.boardState.boardField,
            value: col,
            singleColumn: zoomedIn,
            showIteration: false,
            onCardClick: this._onCardClick,
            onHeaderClick: this._onColumnClick
          });
      return <div className={"column-cell"} id={"col-" + utils.toCssClass(col)} key={ col }>{colView}</div>;
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

  _getVisibleColumns: function() {
    var columns = this.state.boardState.columns;
    if (this.state.visibleColumn) {
      return [this.state.visibleColumn];
    } else {
      return columns;
    }
  },

  _isZoomedIn: function() {
    return !!this.state.visibleColumn;
  },

  _onColumnClick: function(view, column) {
    var me = this;
    me.setState({ visibleColumn: column }, function() {
      me.trigger('columnzoom', column);
    });
  },

  _onCardClick: function(view, model) {
    this.trigger('modelselected', view, model);
  },

  _onAddClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked add card'});
    this.trigger('addnew', this, _.first(this._getVisibleColumns()));
    e.preventDefault();
  },

  _onIterationChange: function(view, iteration) {
    this.getFlux().actions.setIteration(iteration);
  },

  _onIterationSelect: function(view, iteration) {
    this.trigger('modelselected', view, iteration);
  }
});
