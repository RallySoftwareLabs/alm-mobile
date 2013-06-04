define [
  'application',
  'lib/utils'
  'views/field/field_view'
], (app, utils, FieldView) ->

  class FieldWorkProductView extends FieldView

    startEdit: (event) ->
      field = @model.get @options.field
      @publishEvent '!router:route', utils.getDetailHash(field)