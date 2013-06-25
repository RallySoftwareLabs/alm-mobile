define ->
  FieldInputView = require 'views/field/field_input_view'

  class FieldStringWithArrowsView extends FieldInputView

    initialize: ->
      @setEditMode = false
      super
      @delegate 'click', '.arrows-right', @onRightArrow
      @delegate 'click', '.arrows-left', @onLeftArrow
      @delegate 'change', 'select', @onBlur

    getTemplateData: ->
      data = super
      allowedValues = @getAllowedValues()
      data.cantGoLeft = allowedValues.indexOf(data.fieldValue) <= 0
      data.cantGoRight = allowedValues.indexOf(data.fieldValue) is (allowedValues.length - 1)
      data

    onRightArrow: (e) ->
      e.preventDefault()
      e.stopPropagation()
      allowedValues = @getAllowedValues()
      currentIndex = allowedValues.indexOf(@model.get(@options.field))

      if currentIndex < allowedValues.length - 1
        newValue = allowedValues[currentIndex + 1]
        modelUpdates = {}
        modelUpdates[@options.field] = newValue
        @saveModel modelUpdates

    onLeftArrow: (e) ->
      e.preventDefault()
      e.stopPropagation()
      allowedValues = @getAllowedValues()
      currentIndex = allowedValues.indexOf(@model.get(@options.field))

      if currentIndex > 0
        newValue = allowedValues[currentIndex - 1]
        modelUpdates = {}
        modelUpdates[@options.field] = newValue
        @saveModel modelUpdates