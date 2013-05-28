define [
  'lib/utils'
  'views/field/field_view'
], (utils, FieldView) ->

  class FieldOwnerView extends FieldView
    initialize: (config) ->
      @setEditMode = false
      super config

    startEdit: (event) ->
      @saveModel(Owner: @options.session.user.get('_ref'))
