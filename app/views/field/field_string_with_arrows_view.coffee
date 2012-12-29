FieldView = require './field_view'

module.exports = class FieldStringWithArrowsView extends FieldView

  events: ->
    events = super
    events['click .arrows-right'] = 'onRightArrow'
    events['click .arrows-left'] = 'onLeftArrow'
    events

  getRenderData: ->
    data = super
    data.cantGoLeft = @options.allowedValues.indexOf(@model.get(@options.field)) is 0
    data.cantGoRight = @options.allowedValues.indexOf(@model.get(@options.field)) is (@options.allowedValues.length - 1)
    data

  startEdit: ->

  onRightArrow: ->
    allowedValues = @options.allowedValues
    currentIndex = allowedValues.indexOf(@model.get(@options.field))

    if currentIndex < allowedValues.length - 1
      newValue = allowedValues[currentIndex + 1]
      modelUpdates = {}
      modelUpdates[@options.field] = newValue
      @saveModel modelUpdates

  onLeftArrow: ->
    allowedValues = @options.allowedValues
    currentIndex = allowedValues.indexOf(@model.get(@options.field))

    if currentIndex > 0
      newValue = allowedValues[currentIndex - 1]
      modelUpdates = {}
      modelUpdates[@options.field] = newValue
      @saveModel modelUpdates