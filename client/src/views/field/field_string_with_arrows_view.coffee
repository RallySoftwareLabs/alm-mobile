define ->
  FieldView = require 'views/field/field_view'

  class FieldStringWithArrowsView extends FieldView

    initialize: ->
      @setEditMode = false
      super
      @delegate 'click', '.arrows-right', @onRightArrow
      @delegate 'click', '.arrows-left', @onLeftArrow

    getTemplateData: ->
      data = super
      allowedValues = @getAllowedValues()
      data.cantGoLeft = allowedValues.indexOf(data.fieldValue) <= 0
      data.cantGoRight = allowedValues.indexOf(data.fieldValue) is (allowedValues.length - 1)
      data

    startEdit: ->

    onRightArrow: ->
      allowedValues = @getAllowedValues()
      currentIndex = allowedValues.indexOf(@model.get(@options.field))

      if currentIndex < allowedValues.length - 1
        newValue = allowedValues[currentIndex + 1]
        modelUpdates = {}
        modelUpdates[@options.field] = newValue
        @saveModel modelUpdates

    onLeftArrow: ->
      allowedValues = @getAllowedValues()
      currentIndex = allowedValues.indexOf(@model.get(@options.field))

      if currentIndex > 0
        newValue = allowedValues[currentIndex - 1]
        modelUpdates = {}
        modelUpdates[@options.field] = newValue
        @saveModel modelUpdates