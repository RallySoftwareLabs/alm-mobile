define [
  'application',
  'lib/utils'
  'views/field/field_view'
], (app, utils, FieldView) ->

  class FieldWorkProductView extends FieldView

    startEdit: (event) ->
      field = @model.get @options.field
      app.router.navigate(utils.getDetailHash(field), trigger: true)