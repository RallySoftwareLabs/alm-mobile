FieldView = require './field_view'

ToggleFields = ['Blocked', 'Ready']

module.exports = class FieldToggleView extends FieldView

  events: ->
    events = super
    events['click .arrows-right'] = 'onRightArrow'
    events['click .arrows-left'] = 'onLeftArrow'
    events

  startEdit: ->

  onRightArrow: ->
    currentIndex = @options.allowedValues.indexOf(@model.get(@options.field))
    newValue = @options.allowedValues[currentIndex + 1]
    modelUpdates = {}
    modelUpdates[@options.field] = newValue
    @saveModel modelUpdates

  onLeftArrow: ->
    currentIndex = @options.allowedValues.indexOf(@model.get(@options.field))
    newValue = @options.allowedValues[currentIndex - 1]
    modelUpdates = {}
    modelUpdates[@options.field] = newValue
    @saveModel modelUpdates