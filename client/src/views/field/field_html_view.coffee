define [
  'views/field/field_input_view'
], (FieldInputView) ->
  class FieldHtmlView extends FieldInputView

    initialize: ->
      super
      @delegate 'blur', 'textarea', @onBlur
      @delegate 'keydown', 'textarea', @onKeyDown

    onKeyDown: (event) ->
      switch event.which
        when FieldInputView::ESCAPE_KEY then @_switchToViewMode()