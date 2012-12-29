FieldView = require './field_view'

module.exports = class FieldOwnerView extends FieldView
  initialize: (config) ->
    super config

  getRenderData: ->
    data = super
    data.baseUrl = window.AppConfig.almWebServiceBaseUrl
    data

  startEdit: (event) ->
    @saveModel(Owner: @options.session.user.get('_ref'))
