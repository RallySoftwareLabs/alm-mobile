/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var ReactView = require('views/base/react_view');
  var Owner = require('views/board/owner'),
    dragObject, overObject;

  return ReactView.createChaplinClass({
    render: function() {
      var m = this.props.model,
      		cardStyle = {},
      		name = <div className="field name">{m.get('Name')}</div>,
      		owner = <Owner model={m}/>;
      if (m.get('DisplayColor')) {
      	cardStyle.backgroundColor = m.get('DisplayColor');
      	cardStyle.color = 'white';
      }
      return (
        <div className={this.getCardClass(m)} draggable="true" onClick={this.onClick} onDragStart={this.onDragStart} onDragEnd={this.onDragEnd} onDragEnter={this.onDragEnter} onDrop={this.onDrop} onDragOver={this.onDragOver} style={cardStyle}>
          <a className="field formatted-id">{m.get('FormattedID')}</a>
          {owner}
          <div className="clear"/>
          {name}
        </div>
      );
    },
    getCardClass: function(m) {
    	var cardClass = "card full";
      if (m.get('Blocked')) {
      	cardClass += ' blocked';
      }
      if (m.get('Ready')) {
      	cardClass += ' ready';
      }
      if (m.get('DisplayColor')) {
      	cardClass += ' colored';
      }
      return cardClass;
    },
    onClick: function(e) {
    	var m = this.props.model;
    	this.trigger('cardclick', m.get('ObjectID'), m.get('_type'));
    	e.preventDefault();
    },
    onDragStart: function(e){
      $('.card').css({'margin': '10px 0'});
      dragObject = this;
      this.getDOMNode().style.opacity = '0.4'
    },
    onDragEnd: function(e){
      $('.card').css({'margin': '5px 0'});
      this.getDOMNode().style.opacity = '1.0';
      $('.dropzone').remove();
    },
    onDragOver: function(e){
      e.preventDefault();
    },
    onDragEnter: function(e){
      e.preventDefault();
      if (this != dragObject && this != overObject){
        overObject = this;
        $('.dropzone').remove();
        $('<div class="dropzone" style="height: 5px; border-top: solid 3px red;"/>').insertBefore($(this.getDOMNode()));
      }
    },
    onDrop: function(e){
      if (this != dragObject){
        console.log('card picked up the event');
        e.card = dragObject;
        e.dropzone = this;
      }
    },
    componentDidMount: function(rootNode) {
      // var node = this.getDOMNode();
      // var dragObject = this;
      // this.getDOMNode().addEventListener('dragstart', function(e){
      //   this.style.zIndex = 20002;
      //   console.log(this.state);
      //   e.dataTransfer.effectAllowed = 'move';
      //   var data = { dragEnterItem: $(node).data('reactid') };
      //   e.dataTransfer.setData('Text', JSON.stringify(data));
      //   // dragObject = this;
      //   // $('.column .body').each(function(idx, col){
      //   //   var dz = $('<div>').addClass('dropzone')
      //   //   .on('dragover', function(e){
      //   //     e.preventDefault();
      //   //     $(this).parent().addClass('over'); 
      //   //   })
      //   //   .on('dragleave', function(e){
      //   //     $(this).parent().removeClass('over');
      //   //   })
      //   //   .on('drop', function(e){
      //   //     $(this).parent().removeClass('over');
      //   //     console.log(e.target);
      //   //     console.log($(dragObject).data('reactid')); //.getData('text/text'));
      //   //   })
      //   //   .appendTo(col);
      //   // });
      //   this.style.opacity = '0.4';
      // }, false);
      // this.getDOMNode().addEventListener('dragend', function(e){
      //   $('.dropzone').remove();
      //   this.style.opacity = '1';
      // }, false);  
      // this.getDOMNode().addEventListener('drop', function(e){
      //   var data = e.dataTransfer.getData('Text');
      //   console.log('drop data', data);
      //   console.log('drop it like its hot');
      // });

      // node.addEventListener('dragenter', function(e){
      //   e.dataTransfer.dropEffect = 'move';
      //   //$('<div>').addClass('dropzone').insertBefore(this);
      // });
      // node.addEventListener('dragleave', function(e){
      //   var data = e.dataTransfer.getData('Text');
      //   console.log('dragleave data', e.dataTransfer);
      //   //$(this).parent().find('.dropzone').remove();
      // });
      // this.hammer = Hammer(this.getDOMNode(),{prevent_default: false});
      // this.hammer.on('hold', function(e){
      //   console.log('card hold');
      // });
      // this.hammer.on('dragstart', function(e){
      //   var el = this;
      //   
      // });
      // this.hammer.on('tap', this.onClick);
    },
    componentWillUnmount: function() {
      // this.hammer.off('hold');
    }
  });
});