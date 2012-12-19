View = require 'views/view'

module.exports = View.extend
  initialize: (options) ->
    @template = @_getDisplayTemplate(options.field)

  getRenderData: ->
    model: @model.toJSON()
    field: @options.field
    fieldLabel: @options.field
    fieldValue: @model.get(@options.field)

  _getDisplayTemplate: (field) ->
    return require 'views/field/templates/edit/string_view'