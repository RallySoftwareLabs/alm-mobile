/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var CardDefects = require('views/board/card_defects');
var CardTasks = require('views/board/card_tasks');
var Owner = require('views/board/owner');

module.exports = ReactView.createBackboneClass({
  render: function() {
    var m = this.props.model;
    var cardStyle = {};
    var planEstimateMarkup = this._getPlanEstimateMarkup();
    if (m.get('DisplayColor')) {
      cardStyle.borderTopColor = m.get('DisplayColor');
    }
    return (
      <div className={this._getCardClass(m)}
           style={cardStyle}
           tabIndex="0"
           onClick={ this._onClick }
           onKeyDown={ this.handleEnterAsClick(this._onClick) }
           aria-label={ "Card for " + m.get('_type') + " with name: " + m.get('Name') + "." }>
        <a className="field formatted-id" role="link" aria-label={ "Formatted ID. " + m.get('FormattedID') + ". Click to view item." }>{m.get('FormattedID')}</a>
        <Owner model={m}/>
        <div className="clear"/>
        <div className="field name" role="link" aria-label={ "Name. " + m.get('Name') + ". Click to view item." }>{m.get('Name')}</div>
        <CardTasks model={m}/>
        <CardDefects model={m}/>
        <div className="clear"/>
        { planEstimateMarkup }
        <div className="clear"/>
      </div>
    );
  },

  _getCardClass: function(m) {
    var cardClass = "card full";
    if (m.get('Blocked')) {
      cardClass += ' blocked';
    }
    if (m.get('Ready')) {
      cardClass += ' ready';
    }
    return cardClass;
  },

  _getPlanEstimateMarkup: function() {
    var m = this.props.model;
    var planEstimate = m.get('PlanEstimate');
    if (planEstimate != null) {
      return <div className="field plan-estimate" role="link" aria-label={ "Plan Estimate. " + planEstimate + ". Click to view item." }>{ planEstimate }</div>;
    }
    return <div dangerouslySetInnerHTML={{__html: '&nbsp;'}}/>;
  },

  _onClick: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked card'});
    this.props.onCardClick(this, this.props.model);
    e.preventDefault();
  }
});
