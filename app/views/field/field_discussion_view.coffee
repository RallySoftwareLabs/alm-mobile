app = require 'application'

FieldView = require './field_view'

module.exports = class FieldDiscussionView extends FieldView

  startEdit: (event) ->
    field = @model.get @options.field
    app.router.navigate("#{Backbone.history.getHash()}/discussion", trigger: true)