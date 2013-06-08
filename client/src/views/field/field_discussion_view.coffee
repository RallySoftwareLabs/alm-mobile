define ->
  FieldView = require 'views/field/field_view'

  class FieldDiscussionView extends FieldView

    startEdit: (event) ->
      @publishEvent '!router:route', "#{Backbone.history.fragment}/discussion"