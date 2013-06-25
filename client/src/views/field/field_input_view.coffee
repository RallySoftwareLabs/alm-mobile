define ->
  FieldView = require 'views/field/field_view'

  class FieldInputView extends FieldView

    initialize: ->
      super
      @delegate 'blur', 'select', @onBlur
      @delegate 'blur', 'input', @onBlur
      @delegate 'keydown', 'input', @onKeyDown

    onBlur: (event) ->
      @endEdit event

    onKeyDown: (event) ->
      switch event.which
        when @keyCodes.ENTER_KEY then @endEdit event
        when @keyCodes.ESCAPE_KEY then @_switchToViewMode()