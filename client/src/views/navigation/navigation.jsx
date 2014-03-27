/** @jsx React.DOM */
var $ = require('jquery');
var _ = require('underscore');
var React = require('react');
var app = require('application');
var ReactView = require('views/base/react_view');

module.exports = ReactView.createBackboneClass({
  componentDidMount: function() {
    this.subscribeEvent('navigation:show', this.show);
  },
  render: function() {
    return (
      <div className="body row" aria-hidden="true">
        <div className="col-xs-12 buttons">
          {this.getButtons()}
        </div>
      </div>
    );
  },
  getButtons: function() {
    var buttons = [
      {
        displayName: 'Tracking Board',
        viewHash: 'board'
      },
      {
        displayName: app.session.isSelfMode() ? 'My Work' : 'My Team',
        viewHash: 'userstories'
      },
      // {
      //   displayName: 'Burndown Chart'
      //   viewHash: 'burndown'
      // }
      {
        displayName: 'Recent Activity',
        viewHash: 'recentActivity'
      }
    ];
    return _.map(buttons, function(button) {
      return (
        <button className="btn btn-default btn-inverse btn-block" type="button" onClick={ this.onClick(button.viewHash) } key={ button.viewHash }>
          <span className="col-xs-10 display-name">{ button.displayName }</span>
          <span className="col-xs-2 icon"><i className="icon-chevron-right icon-white"></i></span>
        </button>
      );
    }, this);
  },
  onClick: function(viewHash) {
    return _.bind(function() {
      this.hide();
      currentRoute = window.location.pathname;

      if (viewHash !== currentRoute && !(viewHash === '' && _.contains(['/userstories', '/tasks', '/defects'], currentRoute))) {
        this.routeTo(viewHash);
      }
    }, this);
  },
  show: function() {
    var thisEl = $(this.getDOMNode());
    $('#page-container').attr('class', $('#page-container').attr('class').replace(/(\spage\stransition\scenter)?$/, ' page transition right'));
    thisEl.parent().attr('class', thisEl.parent().attr('class').replace(/(transition\s)?left/, 'transition center'));
    $('#mask').show();
    $('#mask').on('click', _.bind(this.hide, this));
  },
  hide: function() {
    var thisEl = $(this.getDOMNode());
    thisEl.parent().attr('class', thisEl.parent().attr('class').replace(/center/, 'left'));
    $('#page-container').attr('class', $('#page-container').attr('class').replace(/right/, 'center'));
    $('#mask').off('click', _.bind(this.hide, this));
    $('#mask').hide();
    this.publishEvent('navigation:hide');
  }
});
