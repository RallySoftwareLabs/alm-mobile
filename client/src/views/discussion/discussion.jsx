/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var ListView = require('views/listing/list');

module.exports = ReactView.createBackboneClass({
  getDefaultProps: function() {
    return {
      showInput: true
    };
  },
  render: function() {
    return (
      <div className="discussion-page">
        {this._getInputMarkup()}
        <ListView
          model={this.props.model}
          noDataMsg="There is no discussion for this item"
          showLoadingIndicator={true}
          showItemArtifact={this.props.showItemArtifact}
          changeOptions="sync"/>
      </div>
    );
  },
  componentDidMount: function() {
    this._getInputField().focus();
  },
  _getInputMarkup: function() {
    if (this.props.showInput) {
      return (
        <form className="reply-form" role="form" onSubmit={this._onSubmit}>
          <div className="discussion-reply input-group">
            <label className="sr-only" htmlFor="comment-input">Comment</label>
            <input ref="inputField" type="text" id="comment-input" className="form-control" placeholder="Enter comments"/>
            <span className="input-group-btn">
             <button type="submit" className="btn btn-primary" onclick={this._onSubmit}>Reply</button>
            </span>
          </div>
        </form>
      );
    }
    return '';
  },
  clearInputField: function() {
    var inputField = this._getInputField();
    inputField.focus();
    inputField.value = '';
  },
  _onSubmit: function(e) {
    app.aggregator.recordAction({component: this, description: 'clicked reply'});
    text = this._getInputField().value;
    this.publishEvent('reply', this, text);
    e.preventDefault();
  },
  _getInputField: function() {
    return this.refs.inputField.getDOMNode();
  }
});
