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
    var appModes = this._getAppModes(currentPage);
    return (
      <div>
        <div className="navbar navbar-inverse" role="navigation">
          <div className="row">
            <div className="left-button">{ this.getLeftButton(currentPage) }</div>
            <div className="title"><div className="ellipsis" role="heading">{ this.state.title }</div></div>
            <div className="right-button">
              <a href="#" className="right" onClick={ this._navigateToFn('search') } aria-label="Search for artifacts"><i className="picto icon-search"></i></a>
            </div>
          </div>
        </div>
        <div className="row app-modes">
          { appModes }
        </div>
      </div>
    );
  },
  getLeftButton: function(currentPage) {
    if (_.contains(['/', '/userstories', '/defects', '/tasks', '/board', '/recentActivity'], currentPage)) {
      return this.makeButton('back', 'chevron-left', 'left invisible', '');
    } else {
      return this.makeButton('back', 'chevron-left', 'left', 'Go Back');
    }
  },
  getRightButton: function(currentPage) {
    if (currentPage === '/settings') {
      return <div/>;
    } else {
      return this.makeButton('settings', 'setup', 'right', 'Change Settings');
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

  _getAppModes: function(currentPage) {
    var appModes = [{
      url: '/board',
      icon: 'board',
      text: 'Board',
      pattern: /^\/board/
    }, {
      url: '/settings',
      icon: 'setup',
      text: 'Setup',
      pattern: /^\/settings(\/board)?$/
    }];
    return _.map(appModes, function(appMode) {
      var isActive = currentPage.match(appMode.pattern);
      return (
        <div key={ appMode.text } className={ "col-xs-6 app-mode " + (isActive ? ' active' : '') } onClick={ this._navigateToFn(appMode.url) }>
          <div>
            <span className={ "picto icon-" + appMode.icon }/>
            <span className="mode-text">{ appMode.text }</span>
          </div>
          <div className="active-border"/>
        </div>
      );
    }, this);
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
