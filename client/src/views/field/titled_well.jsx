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
        editable: true
      };
    },
  	render: function() {
      return (
        <div className={ this.isEditMode() ? 'edit' : 'display' }>
          <div className="well-title control-label">{ (this.props.icon) ? <div className={ "picto icon-" + this.props.icon}/> : '' }{ this.props.label }</div>
          <div className="well well-sm titled-well-sm" onClick={ this._onClick }>{ this._getValueMarkup() }</div>
        </div>
      );
  	},

    _onClick: function() {
      if (this.isEditMode()) {
        return;
      }
      if (this.props.routeTo) {
        this.routeTo(this.props.routeTo);
      } else if (this.props.editable) {
        this.startEdit();
      }
    },

    _getValueMarkup: function() {
      if (this.props.valueMarkup) {
        return this.props.valueMarkup;
      }
      if (this.isEditMode()) {
        if (this.props.item.allowedValues[this.props.field]) {
          return this._getSelectMarkup();
        } else {
          return this.getInputMarkup();
        }
      } else {
        return this._getDisplayMarkup();
      }
    },

    _getDisplayMarkup: function() {
      var fieldValue = this.getFieldValue();
      return fieldValue ? fieldValue : <span dangerouslySetInnerHTML={{__html: '&nbsp;'}} />;
    },

    _getSelectMarkup: function() {
      var options = _.map(this.getAllowedValues(), function(val) {
        var v = val || 'None';
        return <option value={ v } key={ this.props.field + v }>{ v }</option>;
      }, this);
      return (
        <select className={ "editor " + this.props.field }
                defaultValue={ this.getFieldValue() }
                onBlur={ this.endEdit }
                onKeyDown={ this.onKeyDown }>
          { options }
        </select>
      );
    }
  });
});