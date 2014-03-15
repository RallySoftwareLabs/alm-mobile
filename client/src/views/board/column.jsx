/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var _ = require('underscore');
  var ReactView = require('views/base/react_view');
  var app = require('application');
  var utils = require('lib/utils');
  var Card = require('views/board/card');
  var IterationHeader = require('views/iteration_header');

  return ReactView.createBackboneClass({
    getDefaultProps: function() {
      return {showLoadingIndicator: true};
    },
    render: function() {
      var model = this.props.model,
          singleColumn = this.props.singleColumn,
          goLeft = '',
          goRight = '',
          storiesAndDefects = model.artifacts.sortBy(function(m) { return m.get('DragAndDropRank') });
      if (singleColumn && !this.isColumnAtIndex(0)) {
        goLeft = <i className="go-left icon-chevron-left" onClick={this.goLeft}></i>;
      }
      if (singleColumn && !this.isColumnAtIndex(this.props.columns.length - 1)) {
        goRight = <i className="go-right icon-chevron-right" onClick={this.goRight}></i>;
      }
      return (
        <div className="board">
          <IterationHeader visible={this.props.showIteration} />
          <div className={ "column" + (singleColumn ? ' single-column' : ' multi-column') }>
              <div className="header" onClick={this.onHeaderClick}>
                  {goLeft}
                  {this.getColumnHeaderStr(storiesAndDefects)}
                  {goRight}
              </div>
              <div className="body">
                <button className="btn btn-primary add-button" onClick={this.onAddClick}>+ Add</button>
                {this._getCardsMarkup(storiesAndDefects)}
              </div>
          </div>
        </div>
      );
    },
    _getCardsMarkup: function(storiesAndDefects) {
      return _.map(storiesAndDefects, function(model) {
        return <Card key={utils.toRelativeRef(model.get('_ref'))} model={model} />;
      }, this);
    },
    isColumnAtIndex: function(index) {
      return this.props.columns[index] && this.props.columns[index].get('value') == this.props.model.get('value');
    },
    getColumnHeaderStr: function(storiesAndDefects) {
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
    onHeaderClick: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked column'});
      this.publishEvent('headerclick', this.props.model);
      e.preventDefault();
    },
    goLeft: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked left on column'});
      this.publishEvent('goleft', this.props.model);
      e.preventDefault();
      e.stopPropagation();
    },
    goRight: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked right on column'});
      this.publishEvent('goright', this.props.model);
      e.preventDefault();
      e.stopPropagation();
    },	
    onAddClick: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked add card'});
      this.routeTo('board/' + this.props.model.get('value') + '/userstory/new');
      e.preventDefault();
    }
  });
});