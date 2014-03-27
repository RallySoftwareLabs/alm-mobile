/** @jsx React.DOM */
var Backbone = require('backbone');
var React = require('react');
var ReactView = require('views/base/react_view');
var FieldMixin = require('views/field/field_mixin');
var TitledWell = require('views/field/titled_well');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  getDefaultProps: function() {
    return {
      field: 'Children'
    };
  },
  render: function() {
    if (this.isEditMode()) {
      return <div/>;
    };
    return <TitledWell
        field={ this.props.field }
        label="Children"
        item={ this.props.item }
        valueMarkup={ this._getValueMarkup() }
        routeTo={Backbone.history.fragment + '/' + this.props.field.toLowerCase() }/>;
  },

  _getValueMarkup: function() {
    var fieldValue = this.getFieldValue();
    return (
      <div className="status-value children">
          <div className="picto icon-story"/>
          <div className="count">{ fieldValue ? fieldValue.Count : '-' }</div>
      </div>
    );
  }
});
