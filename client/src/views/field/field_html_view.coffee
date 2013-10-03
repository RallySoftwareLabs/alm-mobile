define ->
  FieldInputView = require 'views/field/field_input_view'
  Markdown = require 'pagedown'

  class FieldHtmlView extends FieldInputView

    initialize: ->
      super
      @delegate 'blur', 'textarea', @onBlur
      @delegate 'keydown', 'textarea', @onKeyDown

    onKeyDown: (event) ->
      switch event.which
        when FieldInputView::ESCAPE_KEY then @_switchToViewMode()

    parseValue: (value) ->
      new Markdown.Converter().makeHtml(value).replace(/(\r\n|\n|\r)/gm,"")
