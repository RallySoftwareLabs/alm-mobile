/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var app = require('application');
var FieldMixin = require('views/field/field_mixin');

module.exports = ReactView.createBackboneClass({
  mixins: [FieldMixin],
  render: function() {
    var editMode = this.isEditMode();
    var valueMarkup = editMode ? this._getEditModeMarkup() : this._getDisplayModeMarkup();
    return valueMarkup;
  },

  getFocusNode: function() {
    return this.refs.center.getDOMNode();
  },

  _getDisplayModeMarkup: function() {
    var reverseAllowedValues = this.props.reverseAllowedValues;
    var leftDisabled = reverseAllowedValues ? this._cantGoRight() : this._cantGoLeft();
    var rightDisabled = reverseAllowedValues ? this._cantGoLeft() : this._cantGoRight();

    return (
      <div id={ this.getFieldId() } className="display" aria-label={ this.getFieldAriaLabel() }>
        <div className="well-title control-label" aria-hidden="true">{ this.props.label }</div>
        <div className="arrows-left">
            <div className={ 'well well-sm lt' + (leftDisabled ? ' disabled' : '') }
                 onClick={ this[reverseAllowedValues ? '_onRightArrow' : '_onLeftArrow'] }
                 onKeyDown={ this.handleEnterAsClick(this[reverseAllowedValues ? '_onRightArrow' : '_onLeftArrow']) }
                 tabIndex="0"
                 role="button"
                 aria-labelledby={ !leftDisabled && this.getFieldId() + (reverseAllowedValues ? '-aria-next' : '-aria-previous') }>
              <span className="picto icon-chevron-left"></span>
            </div>
        </div>
        <div className="arrows-center">
          <div className="well well-sm"
               ref="center"
               onClick={ this.startEdit }
               onKeyDown={ this.handleEnterAsClick(this.startEdit) }
               tabIndex="0"
               role="button"
               aria-labelledby={ this.getFieldId() }
               aria-label={ "Click to edit." }>
            { this.getFieldDisplayValue() || this.getEmptySpanMarkup() }
          </div>
        </div>
        <div className="arrows-right">
            <div className={ 'well well-sm lt' + (rightDisabled ? ' disabled' : '') }
                 onClick={ this[reverseAllowedValues ? '_onLeftArrow' : '_onRightArrow'] }
                 onKeyDown={ this.handleEnterAsClick(this[reverseAllowedValues ? '_onLeftArrow' : '_onRightArrow']) }
                 tabIndex="0"
                 role="link"
                 aria-labelledby={ !rightDisabled && this.getFieldId() + (reverseAllowedValues ? '-aria-previous' : '-aria-next') }>
              <span className="picto icon-chevron-right"></span>
            </div>
        </div>
        <div id={ this.getFieldId() + '-aria-previous'} style={{display: "none"}}>
          Click this to change the value of this field from { this.getFieldDisplayValue() } to { this._getPreviousValue() && this._getPreviousValue().label }
        </div>
        <div id={ this.getFieldId() + '-aria-next'} style={{display: "none"}}>
          Click this to change the value of this field from { this.getFieldDisplayValue() } to { this._getNextValue() && this._getNextValue().label }
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
    app.aggregator.recordAction({ component: this, description: 'clicked right arrow of ' + this.props.label + ' field'});
    e.preventDefault();
    e.stopPropagation();
    var newValue = this._getNextValue();

    if (newValue) {
      var modelUpdates = {};
      modelUpdates[this.props.field] = newValue.value;
      this.saveModel(modelUpdates);
    }
  },

  _onLeftArrow: function(e) {
    app.aggregator.recordAction({ component: this, description: 'clicked left arrow of ' + this.props.label + ' field'});
    e.preventDefault();
    e.stopPropagation();
    var newValue = this._getPreviousValue();

    if (newValue) {
      var modelUpdates = {};
      modelUpdates[this.props.field] = newValue.value;
      this.saveModel(modelUpdates);
    }
  },

  _getPreviousValue: function() {
    var allowedValues = this._getNonEmptyAllowedValues();
    var currentIndex = this._indexInAllowedValues();
    var newValue;

    if (currentIndex > 0) {
      newValue = allowedValues[currentIndex - 1];
    }
    return newValue;
  },

  _getNextValue: function() {
    var allowedValues = this._getNonEmptyAllowedValues();
    var currentIndex = this._indexInAllowedValues();
    var newValue;

    if (currentIndex < allowedValues.length - 1) {
      newValue = allowedValues[currentIndex + 1];
    }
    return newValue;
  }
});
