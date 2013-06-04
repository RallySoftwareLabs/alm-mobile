define [
  'application'
  'views/field/field_view'
], (app, FieldView) ->

  class FieldOwnerView extends FieldView
    initialize: (config) ->
      @setEditMode = false
      super config

    startEdit: (event) ->
      @saveModel Owner: app.session.user.get('_ref')
