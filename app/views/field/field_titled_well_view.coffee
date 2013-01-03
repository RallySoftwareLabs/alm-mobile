FieldInputView = require './field_input_view'

module.exports = class FieldTitledWellView extends FieldInputView

  events: ->
    _events = super
    _events['blur select'] = 'onBlur'
    _events['change select'] = 'onBlur'
    _events
