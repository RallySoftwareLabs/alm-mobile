define [
  'views/field/field_input_view'
], (FieldInputView) ->

  class FieldTitledWellView extends FieldInputView

    initialize: ->
      super
      @delegate 'blur', 'select', @onBlur
      @delegate 'change', 'select', @onBlur
      @delegate 'keydown', 'select', @onSelectKeydown

    onSelectKeydown: (event) ->
      switch event.which
        when @ENTER_KEY then @endEdit event
        when @ESCAPE_KEY then @_switchToViewMode()
