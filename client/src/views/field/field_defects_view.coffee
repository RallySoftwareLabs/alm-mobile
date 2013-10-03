define ->
  FieldView = require 'views/field/field_view'

  class FieldDefectsView extends FieldView

    startEdit: (event) ->
      @publishEvent '!router:route', "#{Backbone.history.fragment}/defects"