FieldView = require './field_view'

module.exports = FieldView.extend
  viewMode: 'edit'
  
  afterRender: ->
    @.$el.removeClass('display')
    @.$el.addClass('edit')

  _getViewName: ->
    @viewType