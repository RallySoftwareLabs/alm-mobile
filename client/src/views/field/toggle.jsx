/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      React = require('react'),
      ReactView = require('views/base/react_view'),
      FieldMixin = require('views/field/field_mixin'),
      ToggleFields = ['Blocked', 'Ready'];

  return ReactView.createBackboneClass({
    mixins: [FieldMixin],
    render: function() {
      var fieldValue = this.getFieldValue();
      return (
        <div className={ "display" + (fieldValue ? ' on' : '')}>
          <div className="well well-sm"
            role="link"
            aria-label={ this.getFieldAriaLabel() }
            tabIndex="0"
            onClick={ this._onClick }
            onKeyDown={ this.handleEnterAsClick(this._onClick) }>
              <div className={ "picto icon-" +  this.props.field.toLowerCase() } aria-hidden="true"/>{ this.props.field }
          </div>
        </div>
      );
    },

    _onClick: function() {
      var field = this.props.field,
          updates = {};
      updates[field] = !this.props.item.get(field)
      if (updates[field]) {
        _.each(ToggleFields, function(f) {
          if (f !== field) {
            updates[f] = false;
          }
        }, this);
      }
      this.saveModel(updates);
    }
  });
});