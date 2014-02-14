/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      Backbone = require('backbone'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin'),
      TitledWell = require('views/field/titled_well');

  return ReactView.createBackboneClass({
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
          routeTo={Backbone.history.fragment + '/children' }/>;
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
});