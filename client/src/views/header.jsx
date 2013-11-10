/** @jsx React.DOM */
define(function() {
  var Chaplin = require('chaplin');
  var React = require('react');
  var moment = require('moment');
  var ReactView = require('views/base/react_view');

  return ReactView.createChaplinClass({
    getInitialState: function() {
      return {
        title: 'ALM Mobile'
      }
    },
    componentWillMount: function() {
      this.subscribeEvent('updatetitle', this._onTitleUpdate);
      this.subscribeEvent('dispatcher:dispatch', this._onDispatch);
    },
    render: function() {
      var currentPage = this.getCurrentPage();
      return (
        <div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
          <div class="row">
            <div class="col-xs-2 left-button">{ this.getLeftButton(currentPage) }</div>
            <div class="col-xs-7 title"><div class="ellipsis">{ this.state.title }</div></div>
            <div class="col-xs-3 right-button">
              <a href="#" class="right" onClick={ this._navigateToFn('search') }><i class="picto icon-search"></i></a>
              { this.getRightButton(currentPage) }
            </div>
          </div>
        </div>
      );
    },
    getLeftButton: function(currentPage) {
      if (_.contains(['/', '/userstories', '/defects', '/tasks', '/board', '/recentActivity'], currentPage)) {
        return this.makeButton('navigation', 'grid', 'left');;
      } else {
        return this.makeButton('back', 'back', 'left');
      }
    },
    getRightButton: function(currentPage) {
      if (currentPage === '/settings') {
        return <div/>;
      } else {
        return this.makeButton('settings', 'gear', 'right');
      }
    },
    makeButton: function(target, icon, cls) {
      cls = cls || '';
      return (
        <a href="#" class={ cls } onClick={ this._navigateToFn(target) }>
          <i class={ "picto icon-" + icon }/>
        </a>
      );
    },
    _onTitleUpdate: function(title) {
      this.setState({title: title});
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
        this.publishEvent('!router:route', page);
      }
      e.preventDefault();
    }
  });

});