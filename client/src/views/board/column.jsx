/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      _ = require('underscore'),
      ReactView = require('views/base/react_view'),
      Card = require('views/board/card'),
      IterationHeader = require('views/iteration_header'),
      storiesAndDefects;
  return ReactView.createChaplinClass({
    getDefaultProps: function() {
      return {showLoadingIndicator: true};
    },
    render: function() {
      console.log('rendering column');
      var model = this.props.model,
          singleColumn = this.props.singleColumn,
          goLeft = '',
          goRight = '';
      
      this.storiesAndDefects =  model.artifacts.sortBy(function(m) { return m.get('DragAndDropRank') });

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
                  {this.getColumnHeaderStr(this.storiesAndDefects)}
                  {goRight}
              </div>
              <div className="body" onDragEnter={this.onDragEnter} onDrop={this.onDrop}>{this.getCardsMarkup(this.storiesAndDefects)}</div>
          </div>
        </div>
      );
    },
    getCardsMarkup: function(storiesAndDefects) {
      return _.map(storiesAndDefects, function(model) {
        var card = <Card key={model.get('_ref')} model={model} key={model.get('_ref')} />;
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
    onDrageEnter: function(e){
      e.preventDefault();
    },
    onDrop: function(e){
      if (_.contains(this.storiesAndDefects, e.card.props.model)){
        console.log('exists in column');
      } else {
        console.log('new column');
      }
      var col = this.props.model.artifacts;
      col.beginSync();
      col.reset([]);
      col.finishSync();
      this.render();
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
    // componentDidMount: function(rootNode) {
    //   var body = $(this.getDOMNode()).find('.body');
    //   var col = body.parent();
    //   //var dz = $('<div>').addClass('dropzone')
    //   body.on('dragover dragenter', function(e){
    //     e.preventDefault();
    //     col.addClass('over'); 
    //   })
    //   .on('dragleave', function(e){
    //     col.removeClass('over');
    //   })
    //   .on('drop', function(e){
    //     col.removeClass('over');
    //     console.log(e.target);
    //     //console.log($(dragObject).data('reactid')); //.getData('text/text'));
    //   });
    //   //.appendTo(body);

    // }
  });
});