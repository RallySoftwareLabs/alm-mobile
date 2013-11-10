/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		ListView = require('views/listing/list');

  return ReactView.createChaplinClass({

    componentDidMount: function() {
      this._getInputField().focus();
    },

    getInitialState: function() {
      return {
        keywords: this.props.keywords
      };
    },

    render: function() {
    	return (
        <div id="search-view">
          <form className="form-inline search-form" role="form" onSubmit={ this.onSearch }>
              <div className="input-row">
                <label className="sr-only" htmlFor="search-input">Search keywords</label>
                <span><input type="text" id="search-input" className="form-control" placeholder="Search keywords" value={ this.state.keywords } onChange={ this.handleChange }/></span>
              <button type="submit" className="btn btn-primary">Search</button>
              </div>
          </form>
          <div className="listing">
            <ListView
              model={this.props.collection}
              noDataMsg="No results matched your search."
              showLoadingIndicator={!!this.state.keywords}
              showItemArtifact={this.props.showItemArtifact}
              changeOptions="synced"/>
          </div>
        </div>
      );
    },

    handleChange: function(event) {
      this.setState({keywords: event.target.value});
    },

    onSearch: function(event) {
      this.trigger('search', this._getInputField().val());
      event.preventDefault();
    },

    _getInputField: function() {
      return this.$('.search-form input');
    }
  });
});