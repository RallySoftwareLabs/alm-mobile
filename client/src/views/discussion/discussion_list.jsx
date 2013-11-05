/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
			utils = require('lib/utils'),
  		ReactView = require('views/base/react_view');

  return ReactView.createChaplinClass({
    getDefaultProps: function() {
      return {showLoadingIndicator: true};
    },
    render: function() {
    	var discussionItems = this.props.model.map(this._getDiscussionItemMarkup, this);
    	return <ul className="list-group">{discussionItems}</ul>;
    },
    _getDiscussionItemMarkup: function(item) {
    	return (
    		<li className="list-group-item" key={item.get('_ref')}>
	    		<div className="discussion-item">
	    		    {this._getArtifactMarkup(item)}
	    		    <div className="profile-image">
	    		    	<img src={utils.getProfileImageUrl(item.get('User')._ref, 80)}/>
	    		    </div>
	    		    <div className="details">
	    		    	<div className="status">
	    		    		<span className="profile-link"><span>{item.get('User')._refObjectName}</span></span>
	    		    		<span className="recency">{_(item.get('_CreatedAt')).capitalize()}</span>
	    		    	</div>
	    		    	<div className="detail-text" dangerouslySetInnerHTML={{__html: item.get('Text')}} />
	    		    </div>
	    		</div>
	    	</li>
  		);
    },
    _getArtifactMarkup: function(item) {
    	if (this.props.showItemArtifact) {
    		var artifact = item.get('Artifact');
    		return (
	    		<div className="artifact">
	    		    <a className="artifact-link" href={"/" + utils.getTypeForDetailLink(artifact._type) + "/" + utils.getOidFromRef(artifact._ref)}>{artifact.FormattedID}</a>
	    		    <span className="artifact-name">{artifact._refObjectName}</span>
	    		</div>
	    	);
    	}
  		return '';
    }
  });
});