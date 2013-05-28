define [
  'views/field/field_view'
], (FieldView) ->

  class FieldInputView extends FieldView

    ENTER_KEY: 13
    ESCAPE_KEY: 27

    events: ->
      _events = super
      _events['blur input'] = 'onBlur'
      _events['keydown input'] = 'onKeyDown'
      _events

    onBlur: (event) ->
      @endEdit event

    onKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY then @endEdit event
        when @ESCAPE_KEY then @_switchToViewMode()