/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      _ = require('underscore'),
      ReactView = require('views/base/react_view'),
      Card = require('views/board/card'),
      IterationHeader = require('views/iteration_header');

  return ReactView.createChaplinClass({
    getDefaultProps: function() {
      return {showLoadingIndicator: true};
    },
    render: function() {
      var model = this.props.model,
          showFields = this.props.showFields,
          goLeft = '',
          goRight = '',
          storiesAndDefects = model.artifacts().sortBy(function(m) { return m.get('DragAndDropRank') });
      if (showFields && !this.isColumnAtIndex(0)) {
        goLeft = <i className="go-left icon-chevron-left" onClick={this.goLeft}></i>;
      }
      if (showFields && !this.isColumnAtIndex(this.props.columns.length - 1)) {
        goRight = <i className="go-right icon-chevron-right" onClick={this.goRight}></i>;
      }
      return (
        <div className="board">
          <IterationHeader visible={this.props.showIteration} />
          <div className="column">
              <div className="header" onClick={this.onHeaderClick}>
                  {goLeft}
                  {this.getColumnHeaderStr(storiesAndDefects)}
                  {goRight}
              </div>
              <div className="body">{this.getCardsMarkup(storiesAndDefects, showFields)}</div>
          </div>
        </div>
      );
    },
    getCardsMarkup: function(storiesAndDefects, showFields) {
      return _.map(storiesAndDefects, function(model) {
        var card = <Card key={model.get('_ref')} model={model} showFields={showFields} key={model.get('_ref')} />;
        this.bubbleEvent(card, 'cardclick', 'cardclick');
        return card;
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
      this.trigger('headerclick', this.props.model);
      e.preventDefault();
    },
    goLeft: function(e) {
      this.trigger('goleft', this.props.model);
      e.preventDefault();
      e.stopPropagation();
    },
    goRight: function(e) {
      this.trigger('goright', this.props.model);
      e.preventDefault();
      e.stopPropagation();
    }
  });
});