define ->
  utils = require 'lib/utils'
  FieldView = require 'views/field/field_view'

  class FieldWorkProductView extends FieldView

    afterRender: ->
      super
      @$el.parent().addClass('hidden') unless @getFieldValue()

    startEdit: (event) ->
      field = @model.get @options.field
      @publishEvent '!router:route', utils.getDetailHash(field)