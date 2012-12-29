FieldView = require './field_view'

ToggleFields = ['Blocked', 'Ready']

module.exports = class FieldToggleView extends FieldView
  initialize: (config) ->
    super config
    
  afterRender: ->
    super
    addRemove = if @model.get(@options.field) then 'addClass' else 'removeClass'
    @.$el[addRemove]('on')

  startEdit: (event) ->
    updates = {}
    updates[@options.field] = !@model.get(@options.field)
    (updates[field] = false for field in ToggleFields when field isnt @options.field) if updates[@options.field]
    @saveModel updates

  _otherFieldSave: (field, model) ->
    super field, model
    if field isnt @options.field and field in ToggleFields
      @render()
