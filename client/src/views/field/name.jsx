/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createChaplinClass({
  	mixins: [FieldMixin],
    getDefaultProps: function() {
      return {
        field: 'Name'
      };
    },
  	render: function() {
      if (this.isEditMode()) {
        return <div className="edit"><div className="header">{ this.getInputMarkup() }</div></div>;
      }
  		return <div className="display"><div className="header" onClick={ this._onClick }>{ this.getFieldValue() }</div></div>;
  	},

    _onClick: function(e) {
      this.startEdit();
    }
  });
});