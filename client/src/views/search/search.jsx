/** @jsx React.DOM */
var $ = require('jquery');
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var ListView = require('views/listing/list');

module.exports = ReactView.createBackboneClass({

  componentDidMount: function() {
    this._getInputField().focus();
  },

  render: function() {
    return (
      <div id="search-view">
        <form className="search-form" role="form" onSubmit={ this.onSearch }>
            <div className="input-group">
              <label className="sr-only" htmlFor="search-input">Search keywords</label>
              <input type="text" id="search-input" className="form-control" placeholder="Search keywords" value={ this.props.keywords } onChange={ this.handleChange }/>
              <span className="input-group-btn">
                <button type="submit" className="btn btn-primary">Search</button>
              </span>
            </div>
        </form>
        <div className="listing">
          <ListView
            model={this.props.collection}
            noDataMsg="No results matched your search."
            showLoadingIndicator={!!this.props.keywords}
            showItemArtifact={this.props.showItemArtifact}
            changeOptions="sync"/>
        </div>
      </div>
    );
  },

  handleChange: function(event) {
    this.setProps({keywords: event.target.value});
  },

  onSearch: function(event) {
    app.aggregator.recordAction({component: this, description: 'search submitted'});
    this.publishEvent('search', this._getInputField().val());
    event.preventDefault();
  },

  _getInputField: function() {
    return this.$('.search-form input');
  }
});
