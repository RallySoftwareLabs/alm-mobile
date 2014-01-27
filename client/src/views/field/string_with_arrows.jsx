/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createBackboneClass({
  	mixins: [FieldMixin],
  	render: function() {
  		return (
  			<div className="display">
	  			<div className="well-title control-label">{ this.props.label }</div>
	  			<div className="arrows-left" onClick={ this.onLeftArrow }>
	  			    <div className={ 'well well-sm lt' + (this._cantGoLeft() ? ' disabled' : '') }><i className="picto icon-chevron-left"></i></div>
	  			</div>
	  			<div className="arrows-center">
	  				<div className="well well-sm">
	  					{ this.getFieldValue() }
	  				</div>
	  			</div>
	  			<div className="arrows-right" onClick={ this.onRightArrow }>
	  			    <div className={ 'well well-sm lt' + (this._cantGoRight() ? ' disabled' : '') }><i className="picto icon-chevron-right"></i></div>
	  			</div>
  			</div>
			);
  	},

  	_cantGoLeft: function() {
  		return this._indexInAllowedValues() <= 0;
  	},

  	_cantGoRight: function() {
  		return this._indexInAllowedValues() === this.getAllowedValues().length - 1;
  	},

  	_indexInAllowedValues: function() {
  		return this.getAllowedValues().indexOf(this.getFieldValue());
  	},

    onRightArrow: function(e) {
      e.preventDefault();
      e.stopPropagation();
      var allowedValues = this.getAllowedValues();
      var currentIndex = allowedValues.indexOf(this.props.item.get(this.props.field));

      if (currentIndex < allowedValues.length - 1) {
        var newValue = allowedValues[currentIndex + 1];
        var modelUpdates = {};
        modelUpdates[this.props.field] = newValue;
        this.saveModel(modelUpdates);
      }
    },

    onLeftArrow: function(e) {
      e.preventDefault();
      e.stopPropagation();
      var allowedValues = this.getAllowedValues();
      var currentIndex = allowedValues.indexOf(this.props.item.get(this.props.field));

      if (currentIndex > 0) {
        var newValue = allowedValues[currentIndex - 1];
        var modelUpdates = {};
        modelUpdates[this.props.field] = newValue;
        this.saveModel(modelUpdates);
      }
    }
  });
});