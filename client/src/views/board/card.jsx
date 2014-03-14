/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var ReactView = require('views/base/react_view');
  var app = require('application');
  var CardDefects = require('views/board/card_defects');
  var CardTasks = require('views/board/card_tasks');
  var Owner = require('views/board/owner');

  return ReactView.createBackboneClass({
    render: function() {
      var m = this.props.model,
      		cardStyle = {};
      if (m.get('DisplayColor')) {
      	cardStyle.backgroundColor = m.get('DisplayColor');
      	cardStyle.color = 'white';
      }
      return (
        <div className={this.getCardClass(m)}
             style={cardStyle}
             onClick={this._onClick}
             aria-label={ "Card for " + m.get('_type') + " with name: " + m.get('Name') + "." }>
          <a className="field formatted-id" role="link" aria-label={ "Formatted ID. " + m.get('FormattedID') + ". Click to view item." }>{m.get('FormattedID')}</a>
          <Owner model={m}/>
          <div className="clear"/>
          <div className="field name" role="link" aria-label={ "Name. " + m.get('Name') + ". Click to view item." }>{m.get('Name')}</div>
          <CardTasks model={m}/>
          <CardDefects model={m}/>
          <div className="clear"/>
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
    _onClick: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked card'});
    	this.publishEvent('cardclick', this, this.props.model);
    	e.preventDefault();
    }
  });
});