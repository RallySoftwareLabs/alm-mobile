/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      Backbone = require('backbone'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin'),
      StringWithArrows = require('views/field/string_with_arrows');

  return ReactView.createBackboneClass({
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
});