/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createBackboneClass({
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
  		return <div className="display"><div className="header" role="link" onClick={ this._onClick } aria-label={ "Name. " + this.getFieldValue() + ". Click to edit" }>{ this.getFieldValue() }</div></div>;
  	},

    _onClick: function(e) {
      this.startEdit();
    }
  });
});