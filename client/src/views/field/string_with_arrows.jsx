/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
			React = require('react'),
  		ReactView = require('views/base/react_view'),
      app = require('application'),
  		FieldMixin = require('views/field/field_mixin');

  return ReactView.createBackboneClass({
  	mixins: [FieldMixin],
  	render: function() {
      var editMode = this.isEditMode();
      var valueMarkup = editMode ? this._getEditModeMarkup() : this._getDisplayModeMarkup();
  		return valueMarkup;
  	},

    _getDisplayModeMarkup: function() {
      var reverseArrows = this.props.reverseArrows;
      return (
        <div className="display">
          <div className="well-title control-label">{ this.props.label }</div>
          <div className="arrows-left" onClick={ this[reverseArrows ? '_onRightArrow' : '_onLeftArrow'] }>
              <div className={ 'well well-sm lt' + (this[reverseArrows ? '_cantGoRight' : '_cantGoLeft']() ? ' disabled' : '') }><i className="picto icon-chevron-left"></i></div>
          </div>
          <div className="arrows-center">
            <div className="well well-sm" onClick={ this.startEdit }>
              { this.getFieldDisplayValue() || this.getEmptySpanMarkup() }
            </div>
          </div>
          <div className="arrows-right" onClick={ this[reverseArrows ? '_onLeftArrow' : '_onRightArrow'] }>
              <div className={ 'well well-sm lt' + (this[reverseArrows ? '_cantGoLeft' : '_cantGoRight']() ? ' disabled' : '') }><i className="picto icon-chevron-right"></i></div>
          </div>
        </div>
      );
    },

    _getEditModeMarkup: function() {
      var selectMarkup = this.getAllowedValuesSelectMarkup();
      return (
        <div className="edit">
          <div className="well-title control-label">{ this.props.label }</div>
          <div className="well well-sm">
            { selectMarkup }
          </div>
        </div>
      );
    },

  	_cantGoLeft: function() {
  		return this._indexInAllowedValues() <= 0;
  	},

  	_cantGoRight: function() {
      var index = this._indexInAllowedValues();
  		return index === this._getNonEmptyAllowedValues().length - 1 || index === -1;
  	},

    _getNonEmptyAllowedValues: function() {
      var av = this.getAllowedValues();
      if (app.session.get('boardField') == this.props.field) {
        var boardColumns = app.session.getBoardColumns();
        if (_.contains(boardColumns, this.getFieldValue())) {
          av = _.filter(av, function(value) {
            return _.contains(boardColumns, value.label);
          });
        } else {
          av = null;
        }
      }
      return _.reject(av, { value: 'null'});
    },

  	_indexInAllowedValues: function() {
      var fieldValue = this.getFieldValue();
      if (_.isObject(fieldValue)) {
        fieldValue = fieldValue._ref;
      }
      return _.findIndex(this._getNonEmptyAllowedValues(), function(value) {
        return fieldValue === value.value;
      }, this);
  	},

    _onRightArrow: function(e) {
      e.preventDefault();
      e.stopPropagation();
      var allowedValues = this._getNonEmptyAllowedValues();
      var currentIndex = this._indexInAllowedValues();

      if (currentIndex < allowedValues.length - 1) {
        var newValue = allowedValues[currentIndex + 1];
        var modelUpdates = {};
        modelUpdates[this.props.field] = newValue.value;
        this.saveModel(modelUpdates);
      }
    },

    _onLeftArrow: function(e) {
      e.preventDefault();
      e.stopPropagation();
      var allowedValues = this._getNonEmptyAllowedValues();
      var currentIndex = this._indexInAllowedValues();

      if (currentIndex > 0) {
        var newValue = allowedValues[currentIndex - 1];
        var modelUpdates = {};
        modelUpdates[this.props.field] = newValue.value;
        this.saveModel(modelUpdates);
      }
    }
  });
});