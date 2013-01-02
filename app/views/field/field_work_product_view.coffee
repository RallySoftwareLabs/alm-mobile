app = require 'application'
utils = require 'lib/utils'

FieldView = require './field_view'

module.exports = class FieldWorkProductView extends FieldView

  startEdit: (event) ->
    field = @model.get @options.field
    app.router.navigate(utils.getDetailHash(field), trigger: true)