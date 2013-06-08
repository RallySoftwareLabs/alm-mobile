define ->
  FieldInputView = require 'views/field/field_input_view'

  class FieldTitledWellView extends FieldInputView

    initialize: ->
      super
      @delegate 'blur', 'select', @onBlur
      @delegate 'change', 'select', @onBlur
      @delegate 'keydown', 'select', @onSelectKeydown

    onSelectKeydown: (event) ->
      switch event.which
        when @keyCodes.ENTER_KEY then @endEdit event
        when @keyCodes.ESCAPE_KEY then @_switchToViewMode()
