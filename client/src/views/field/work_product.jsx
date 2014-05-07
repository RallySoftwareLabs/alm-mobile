/** @jsx React.DOM */
var $ = require('jquery');
var React = require('react');
var utils = require('lib/utils');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  getDefaultProps: function() {
    return { label: 'Work Product' };
  },
  render: function() {
    var fieldValue = this.getFieldValue();
    return fieldValue ? (
      <div className="display">
        <div className="well-title control-label">{ this.props.label }</div>
        <div className="well well-sm titled-well-sm"
             onClick={ this._onClick }
             onKeyDown={ this.handleEnterAsClick(this._onClick) }
             tabIndex="0"
             role="link"
             aria-label={ "Work Product. " + fieldValue.FormattedID + ": " + fieldValue._refObjectName + " Click to edit." }>
          <span className="work-product-id">{ fieldValue.FormattedID }</span>
          <span className="work-product-name">{ fieldValue._refObjectName }</span>
        </div>
      </div>
    ) : <div/>;
  },

  _onClick: function() {
    var fieldValue = this.getFieldValue();
    this.routeTo(utils.getDetailHash(fieldValue));
  }
});
