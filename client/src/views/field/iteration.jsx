/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');
var StringWithArrows = require('views/field/string_with_arrows');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  getDefaultProps: function() {
    return {
      reverseArrows: true
    };
  },
  render: function() {
    return this.transferPropsTo(<StringWithArrows/>);
  }
});
