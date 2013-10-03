define ->
  FieldView = require 'views/field/field_view'

  class FieldTasksView extends FieldView

    startEdit: (event) ->
      @publishEvent '!router:route', "#{Backbone.history.fragment}/tasks"