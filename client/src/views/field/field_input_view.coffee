define [
  'views/field/field_view'
], (FieldView) ->

  class FieldInputView extends FieldView

    ENTER_KEY: 13
    ESCAPE_KEY: 27

    initialize: ->
      super
      @delegate 'blur', 'input', @onBlur
      @delegate 'keydown', 'input', @onKeyDown

    onBlur: (event) ->
      @endEdit event

    onKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY then @endEdit event
        when @ESCAPE_KEY then @_switchToViewMode()