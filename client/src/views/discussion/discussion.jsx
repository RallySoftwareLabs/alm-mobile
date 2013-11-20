/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		ListView = require('views/listing/list');

  return ReactView.createChaplinClass({
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
              changeOptions="synced"/>
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
					<form className="form-inline reply-form" role="form" onSubmit={this._onSubmit}>
					    <div className="discussion-reply">
					      <label className="sr-only" htmlFor="comment-input">Comment</label>
					      <span><input type="text" id="comment-input" className="form-control" placeholder="Enter comments"/></span>
					      <button type="submit" className="btn btn-primary" onclick={this._onSubmit}>Reply</button>
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
      text = this._getInputField().val();
      this.trigger('reply', text);
      event.preventDefault();
    },
    _getInputField: function() {
      return $(this.getDOMNode()).find('.discussion-reply input');
    }
  });
});