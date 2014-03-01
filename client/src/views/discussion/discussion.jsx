/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
      app = require('application'),
  		ListView = require('views/listing/list');

  return ReactView.createBackboneClass({
  	getDefaultProps: function() {
  		return {
  			showInput: true
  		};
  	},
    render: function() {
    	return (
    		<div className="discussion-page">
    			{this._getInputMarkup()}
	        <div className="listing">
            <ListView
              model={this.props.model}
              noDataMsg="There is no discussion for this item"
              showLoadingIndicator={true}
              showItemArtifact={this.props.showItemArtifact}
              changeOptions="sync"/>
	        </div>
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
				      <input type="text" id="comment-input" className="form-control" placeholder="Enter comments"/>
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
      inputField.val('');
    },
    _onSubmit: function(event) {
      app.aggregator.recordAction({component: this, description: 'clicked reply'});
      text = this._getInputField().val();
      this.publishEvent('reply', text);
      event.preventDefault();
    },
    _getInputField: function() {
      return $(this.getDOMNode()).find('.discussion-reply input');
    }
  });
});