/** @jsx React.DOM */
var React = require('react');
var app = require('application');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  getDefaultProps: function() {
    return {
      field: 'Owner'
    };
  },
  render: function() {
    var owner = this.props.item.get('Owner');
    return (
      <div className="display">
        <div className="owner-field"
             tabIndex="0"
             onClick={ this._onClick }
             onKeyDown={ this.handleEnterAsClick(this._onClick) }
             aria-label={ "Owner. " + (owner ? "Owned by " + this.getFieldValue()._refObjectName : "Not currently owned") + ". Click to set yourself as the owner." }>
          { this._getProfileImageMarkup() }{ this._getNameMarkup() }
        </div>
      </div>
    );
  },

  _onClick: function() {
    this.saveModel({Owner: app.session.get('user').toJSON()});
  },

  _getProfileImageMarkup: function() {
    var fieldValue = this.getFieldValue();
    if (this.props.item.get('Owner')) {
        return <div className="profile-image" style={{backgroundImage: 'url(' + utils.getProfileImageUrl(fieldValue._ref, 160) + ')', backgroundRepeat: 'no-repeat', backgroundSize: 'contain'}}/>;
    }
    return <div className="profile-image"><div className="picto icon-user-add"/></div>;
  },

  _getNameMarkup: function() {
    var fieldValue = this.getFieldValue();
    if (this.props.item.get('Owner')) {
        return <div className="name ellipsis" title={ fieldValue._refObjectName } aria-hidden="true">{ fieldValue._refObjectName }</div>;
    }
    return <div className="name" aria-hidden="true">Claim</div>;
  }
});
