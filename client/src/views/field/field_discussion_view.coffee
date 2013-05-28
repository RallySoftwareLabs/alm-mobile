define [
  'application',
  'views/field/field_view'
], (app, FieldView) ->
  class FieldDiscussionView extends FieldView

    startEdit: (event) ->
      field = @model.get @options.field
      app.router.navigate("#{Backbone.history.getHash()}/discussion", trigger: true)