define [
  'application',
  'views/field/field_view'
], (app, FieldView) ->
  class FieldDiscussionView extends FieldView

    startEdit: (event) ->
      @publishEvent '!router:route', "#{Backbone.history.fragment}/discussion"