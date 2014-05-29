/** @jsx React.DOM */
var React = require('react');
var _ = require('underscore');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var app = require('application');
var Card = require('views/board/card');

module.exports = ReactView.createBackboneClass({
  propTypes: {
    onHeaderClick: React.PropTypes.func.isRequired,
    onCardClick: React.PropTypes.func.isRequired
  },
  render: function() {
    var model = this.props.model,
        singleColumn = this.props.singleColumn,
        goLeft = '',
        goRight = '',
        storiesAndDefects = model.artifacts.sortBy(_.getAttribute('DragAndDropRank'));
    if (singleColumn && !this.isColumnAtIndex(0)) {
      goLeft = <i className="go-left icon-chevron-left"
                  onClick={this._goLeft}
                  onKeyDown={this.handleEnterAsClick(this._goLeft)}
                  role="link"
                  aria-label="Go to previous column"
                  tabIndex="0"/>;
    }
    if (singleColumn && !this.isColumnAtIndex(this.props.columns.length - 1)) {
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
              onClick={this._onHeaderClick}
              onKeyDown={ this.handleEnterAsClick(this._onHeaderClick) }
              tabIndex="0"
              aria-label={ "Board column: " + model.get('value') +
                           (model.isSynced() ? ". has " + storiesAndDefects.length + " items" : ". loading") }>
                {goLeft}
                {this._getColumnHeaderStr(storiesAndDefects)}
                {goRight}
            </div>
            <div className="body">
              <button className="btn btn-primary add-button" onClick={this._onAddClick} aria-label="Add new story to this column" tabIndex="0">+ Add</button>
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
  isColumnAtIndex: function(index) {
    return this._getIndexInColumns() === index;
  },
  _getIndexInColumns: function() {
    return _.findIndex(this.props.columns, _.isAttributeEqual('value', this.props.model.get('value')));
  },
  _getColumnHeaderStr: function(storiesAndDefects) {
    var model = this.props.model,
        fieldValue = model.get('value'),
        str;

    if (this.props.abbreviateHeader) {
      str = _.map(fieldValue.replace(/-/g, ' ').split(' '), function(word) {
        return word[0];
      }).join('');
    } else {
      str = fieldValue;
    }
    return str + (model.isSynced() ? " (" + storiesAndDefects.length + ")" : " ...");
  },
  _onHeaderClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked column'});
    this.props.onHeaderClick(this, this.props.model);
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
  },  
  _onAddClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked add card'});
    this.routeTo('board/' + this.props.model.get('value') + '/userstory/new');
    e.preventDefault();
  }
});
