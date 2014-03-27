/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');

module.exports = ReactView.createBackboneClass({
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
    return (
      <div className="display">
        <div className="header"
             role="link"
             onClick={ this._onClick }
             onKeyDown={ this.handleEnterAsClick(this._onClick) }
             aria-label={ "Name. " + this.getFieldValue() + ". Click to edit" }
             tabIndex="0">
          { this.getFieldValue() }
        </div>
      </div>
    );
  },

  _onClick: function(e) {
    this.startEdit();
  }
});
