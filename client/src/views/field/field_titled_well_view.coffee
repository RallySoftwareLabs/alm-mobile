define [
  'views/field/field_input_view'
], (FieldInputView) ->

  class FieldTitledWellView extends FieldInputView

    events: ->
      _events = super
      _events['blur select'] = 'onBlur'
      _events['change select'] = 'onBlur'
      _events['keydown select'] = 'onSelectKeydown'
      _events

    onSelectKeydown: (event) ->
      switch event.which
        when @ENTER_KEY then @endEdit event
        when @ESCAPE_KEY then @_switchToViewMode()
