/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var ReactView = require('views/base/react_view');
  var app = require('application');
  var Owner = require('views/board/owner');

  return ReactView.createBackboneClass({
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
        <div className={this.getCardClass(m)} style={cardStyle} onClick={this.onClick}>
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
      app.aggregator.recordAction({component: this, description: 'clicked card'});
    	this.publishEvent('cardclick', m.get('ObjectID'), m.get('_type'));
    	e.preventDefault();
    }
  });
});