/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      Backbone = require('backbone'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin'),
      TitledWell = require('views/field/titled_well');

  return ReactView.createChaplinClass({
    mixins: [FieldMixin],
    getDefaultProps: function() {
      return {
        field: 'Tasks'
      };
    },
    render: function() {
      if (this.props.editMode) {
        return <div/>;
      };
      return <TitledWell
          field={ this.props.field }
          label="Tasks"
          item={ this.props.item }
          valueMarkup={ this._getValueMarkup() }
          routeTo={Backbone.history.fragment + '/tasks' }/>;
    },

    _getValueMarkup: function() {
      var fieldValue = this.getFieldValue();
      return (
        <div className="status-value tasks">
            <div className="picto icon-task"/>
            <div className="count">{ fieldValue ? fieldValue.Count : '-' }</div>
        </div>
      );
    }
  });
});