/** @jsx React.DOM */
var $ = require('jquery');
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');

module.exports = ReactView.createBackboneClass({
  render: function() {
    return (
      <div id="login">
        <div className="login-header">
          <a className="labs-link" title="Rally Innovation Labs" href="//labs.rallydev.com">
            <img src="img/logo-labs.gif" alt="Rally Innovation Labs"/>
          </a>
        </div>
        <form className="login-form" role="form" onSubmit={this.signIn}>
          <div className="form-group">
            <h2>Sign in to Rally</h2>
          </div>
          <div className="alert alert-danger"/>
          <div className="form-group">
            <label className="control-label" htmlFor="username">Username</label>
            <div>
              <input className="form-control" type="text" id="username" placeholder="Username" defaultValue="" autoFocus="true" tabIndex="0"/>
            </div>
          </div>
          <div className="form-group">
            <label className="control-label" htmlFor="password">Password</label>
            <div>
              <input className="form-control" type="password" id="password" placeholder="Password" defaultValue="" tabIndex="0"/>
            </div>
          </div>
          <div className="form-group">
            <div className="control-label">
              <button type="submit" className="btn btn-lg btn-primary sign-in" tabIndex="0">Sign in</button>
            </div>
          </div>
          <div className="form-group copyright">
            <small>&copy; 2003-{new Date().getFullYear()} Rally Software Development Corp.</small>
          </div>
        </form>
      </div>
    );
  },

  componentDidMount: function() {
    $('body').addClass('login-body');
    if (window.loginError) {
      $('.alert').html(window.loginError).show();
      delete window.loginError;
    }
  },

  componentWillUnmount: function() {
    $('body').removeClass('login-body');
  },

  signIn: function(event) {
    app.aggregator.recordAction({component: this, description: 'logging in'});
    $('.alert').hide();
    username = $('#username').val();
    password = $('#password').val();
    this.publishEvent('submit', username, password);
    event.preventDefault();
  },

  showError: function(error) {
    $('#password').html('');
    $('.alert').html(error).show();
  }
});
