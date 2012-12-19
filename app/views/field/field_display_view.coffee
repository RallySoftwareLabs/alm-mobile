FieldView = require './field_view'

module.exports = FieldView.extend
  viewMode: 'display'

  afterRender: ->
    @.$el.removeClass('edit')
    @.$el.addClass('display')
    
  _getViewName: ->
    @viewType