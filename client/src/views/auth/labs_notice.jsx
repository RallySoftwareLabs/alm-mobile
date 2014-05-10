/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');

module.exports = ReactView.createBackboneClass({
  render: function() {
    return (
      <div id="labs-notice" className="container">
        <div className="jumbotron">
          <div className="labs-icon">
            <a className="labs-link" title="Rally Innovation Labs" href="//labs.rallydev.com">
              <img src="img/logo-labs.gif" alt="Rally Innovation Labs"/>
            </a>
          </div>
          <p>
            Development of the mobile Rally Software ALM platform is a project of Rally Innovation Labs.
            For more info, visit <a href="http://labs.rallydev.com">http://labs.rallydev.com</a>.
          </p>
          <p>
            Use of this mobile application is on an as-is, as-available basis
            and it not subject to Rally’s Service Level Agreement.
            Support of this mobile application, evolution of this application
            and even ongoing existence of this Rally Labs mobile application is not guaranteed.
          </p>
          <p><a className="btn btn-primary btn-lg accept" tabIndex="0" onClick={this.accept}>Accept</a> <a className="btn btn-lg reject" tabIndex="0" onClick={this.reject}>Reject</a></p>
        </div>
      </div>
    );
  },

  accept: function(e) {
    app.aggregator.recordAction({component: this, description: 'accepted labs notice'});
    this.publishEvent('accept');
    e.preventDefault();
  },

  reject: function(e) {
    app.aggregator.recordAction({component: this, description: 'rejected labs notice'});
    this.publishEvent('reject');
    e.preventDefault();
  }
});
