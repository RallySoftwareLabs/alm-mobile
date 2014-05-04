/** @jsx React.DOM */
var React = require('react');
var moment = require('moment');
var ReactView = require('views/base/react_view');

module.exports = ReactView.createBackboneClass({
  getInitialState: function() {
    return {
      title: 'Rally ALM Mobile'
    }
  },
  componentWillMount: function() {
    this.subscribeEvent('updatetitle', this._onTitleUpdate);
    this.subscribeEvent('urlchanged', this._onDispatch);
  },
  render: function() {
    var currentPage = this.getCurrentPage();
    return (
      <div className="navbar navbar-inverse navbar-fixed-top" role="navigation">
        <div className="row">
          <div className="col-xs-2 left-button">{ this.getLeftButton(currentPage) }</div>
          <div className="col-xs-7 title"><div className="ellipsis" role="heading">{ this.state.title }</div></div>
          <div className="col-xs-3 right-button">
            <a href="#" className="right" onClick={ this._navigateToFn('search') } aria-label="Search for artifacts"><i className="picto icon-search"></i></a>
            { this.getRightButton(currentPage) }
          </div>
        </div>
      </div>
    );
  },
  getLeftButton: function(currentPage) {
    if (_.contains(['/', '/userstories', '/defects', '/tasks', '/board', '/recentActivity'], currentPage)) {
      return <span/>;//this.makeButton('navigation', 'grid', 'left');
    } else {
      return this.makeButton('back', 'back', 'left', 'Go Back');
    }
  },
  getRightButton: function(currentPage) {
    if (currentPage === '/settings') {
      return <div/>;
    } else {
      return this.makeButton('settings', 'gear', 'right', 'Change Settings');
    }
  },
  makeButton: function(target, icon, cls, ariaLabel) {
    cls = cls || '';
    return (
      <a href="#" className={ cls } onClick={ this._navigateToFn(target) } aria-label={ ariaLabel }>
        <i className={ "picto icon-" + icon }/>
      </a>
    );
  },
  _onTitleUpdate: function(title) {
    this.setState({ title: title }, function() {
      document.title = title + ' - Rally ALM Mobile'
    });
  },
  _onDispatch: function() {
    if (this.isMounted()) {
      this.forceUpdate();
    }
  },
  getCurrentPage: function() {
    return window.location.pathname;
  },
  _navigateToFn: function(target) {
    return _.bind(function(e) { this._navigateTo(target, e); }, this);
  },
  _navigateTo: function(page, e) {
    if (page === 'back') {
      window.history.back();
    } else if (page === 'navigation') {
      this.publishEvent('navigation:show');
    } else {
      this.routeTo(page);
    }
    e.preventDefault();
  }
});
