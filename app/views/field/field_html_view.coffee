FieldInputView = require './field_input_view'

module.exports = class FieldHtmlView extends FieldInputView

  events: ->
    _events = super
    _events['blur textarea'] = 'onBlur'
    _events['keydown textarea'] = 'onKeyDown'
    _events

  onKeyDown: (event) ->
    switch event.which
      when FieldInputView::ESCAPE_KEY then @_switchToViewMode()