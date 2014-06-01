/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var app = require('application');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var Card = require('views/board/card');

module.exports = ReactView.createBackboneClass({
  propTypes: {
    onHeaderClick: React.PropTypes.func.isRequired,
    onCardClick: React.PropTypes.func.isRequired
  },
  render: function() {
    var storiesAndDefects = this._getMatchingArtifacts(),
        singleColumn = this.props.singleColumn,
        goLeft = '',
        goRight = '';
    if (singleColumn && !this._isColumnAtIndex(0)) {
      goLeft = <i className="go-left icon-chevron-left"
                  onClick={this._goLeft}
                  onKeyDown={this.handleEnterAsClick(this._goLeft)}
                  role="link"
                  aria-label="Go to previous column"
                  tabIndex="0"/>;
    }
    if (singleColumn && !this._isColumnAtIndex(this.props.columns.length - 1)) {
      goRight = <i className="go-right icon-chevron-right"
                   onClick={this._goRight}
                   onKeyDown={this.handleEnterAsClick(this._goRight)}
                   role="link"
                   aria-label="Go to next column"
                   tabIndex="0"/>;
    }
    return (
      <div className="board">
        <div className={ "column" + (singleColumn ? ' single-column' : ' multi-column') }>
            <div className="header"
              ref="header"
              onClick={this._onHeaderClick}
              onKeyDown={ this.handleEnterAsClick(this._onHeaderClick) }
              tabIndex="0"
              aria-label={ "Board column: " + this.props.value +
                           (this.props.artifacts.isSynced() ? ". has " + storiesAndDefects.length + " items" : ". loading") }>
                {goLeft}
                {this._getColumnHeaderStr(storiesAndDefects)}
                {goRight}
            </div>
            <div className="body">
              {this._getCardsMarkup(storiesAndDefects)}
            </div>
        </div>
      </div>
    );
  },

  _getCardsMarkup: function(storiesAndDefects) {
    return _.map(storiesAndDefects, function(model, idx) {
      return <Card key={utils.toRelativeRef(model.get('_ref'))} model={model} onCardClick={this._onCardClick}/>;
    }, this);
  },

  _getMatchingArtifacts: function() {
    var matchingArtifacts = this.props.artifacts.filter(_.isAttributeEqual(this.props.boardField, this.props.value));
    return _.sortBy(matchingArtifacts, _.getAttribute('DragAndDropRank'));
  },

  _isColumnAtIndex: function(index) {
    return this._getIndexInColumns() === index;
  },

  _getIndexInColumns: function() {
    return _.findIndex(this.props.columns, function(column) { return column === this.props.value}, this);
  },

  _getColumnHeaderStr: function(storiesAndDefects) {
    var fieldValue = this.props.value,
        str;

    if (this.props.abbreviateHeader) {
      str = _.map(fieldValue.replace(/-/g, ' ').split(' '), function(word) {
        return word[0];
      }).join('');
    } else {
      str = fieldValue;
    }
    return str + (this.props.artifacts.isSynced() ? " (" + storiesAndDefects.length + ")" : " ...");
  },

  _onHeaderClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked column'});
    this.props.onHeaderClick(this, this.props.value);
    e.preventDefault();
  },

  _onCardClick: function(view, model) {
    this.props.onCardClick(view, model);
  },

  _goLeft: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked left on column'});
    this.props.onHeaderClick(this, this.props.columns[this._getIndexInColumns() - 1]);
    e.preventDefault();
    e.stopPropagation();
  },

  _goRight: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked right on column'});
    this.props.onHeaderClick(this, this.props.columns[this._getIndexInColumns() + 1]);
    e.preventDefault();
    e.stopPropagation();
  }
});
