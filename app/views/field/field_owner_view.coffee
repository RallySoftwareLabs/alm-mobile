utils = require 'lib/utils'
FieldView = require './field_view'

module.exports = class FieldOwnerView extends FieldView
  initialize: (config) ->
    @setEditMode = false
    super config

  startEdit: (event) ->
    @saveModel(Owner: @options.session.user.get('_ref'))
