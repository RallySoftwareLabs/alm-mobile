/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
      utils = require('lib/utils'),
  		ReactView = require('views/base/react_view'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createChaplinClass({
  	mixins: [FieldMixin],
    getDefaultProps: function() {
      return { label: 'Work Product' };
    },
  	render: function() {
      var fieldValue = this.getFieldValue();
  		return fieldValue ? (
        <div className="display">
          <div className="well-title control-label">{ this.props.label }</div>
          <div className="well well-sm titled-well-sm" onClick={ this._onClick }>
            <span className="work-product-id">{ fieldValue.FormattedID }</span>
            <span className="work-product-name ellipsis">{ fieldValue._refObjectName }</span>
          </div>
        </div>
      ) : <div/>;
  	},

    _onClick: function() {
      var fieldValue = this.getFieldValue();
      this.routeTo(utils.getDetailHash(fieldValue));
    }
  });
});