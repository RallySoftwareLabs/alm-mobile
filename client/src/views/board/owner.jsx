/** @jsx React.DOM */
define(function() {
  var React = require('react');
  var utils = require('lib/utils');
  var ReactView = require('views/base/react_view');

  return ReactView.createChaplinClass({
    render: function() {
      var m = this.props.model,
          ownerName,
          profileImageStyle = {},
          profileImage = '';

      if (m.get('Owner')) {
        ownerName = m.get('Owner')._refObjectName;
      	profileImageStyle.backgroundImage = "url(" + utils.getProfileImageUrl(m.get('Owner')._ref, 50) + ")";
      } else {
        ownerName = "No owner";
        profileImage = <div className="picto icon-user-add"/>;
      }
      return (
        <div className="field owner">
          <div className="owner-name">
            {ownerName}
          </div>
          <div className="profile-image" style={profileImageStyle}>{profileImage}</div>
        </div>
      );
    }
  });
});