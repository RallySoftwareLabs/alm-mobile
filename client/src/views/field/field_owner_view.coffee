define ->
  app = require 'application'
  FieldView = require 'views/field/field_view'

  class FieldOwnerView extends FieldView
    initialize: (config) ->
      @setEditMode = false
      super config

    startEdit: (event) ->
      @saveModel Owner: app.session.get('user').get('_ref')
