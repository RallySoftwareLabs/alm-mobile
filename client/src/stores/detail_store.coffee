Promise = require('es6-promise').Promise
_ = require 'underscore'
app = require 'application'
utils = require 'lib/utils'
Artifacts = require 'collections/artifacts'
Iteration = require 'models/iteration'
BaseStore = require 'stores/base_store'

module.exports = class DetailStore extends BaseStore

  saveField: (view, updates, opts) ->
    if @getModel().get('_ref')
      @_saveRemote(view, updates, opts)
    else
      @_saveLocal(view, updates, opts)

  saveNew: (view, model) ->
    model.save null,
      shallowFetch: @getFieldNames().join ','
      wait: true
      patch: true
      success: (resp, status, xhr) =>
        opts?.success?(model, resp)
        @publishEvent 'router:changeURL', utils.getDetailHash(model), replace: true
        @_setTitle model
      error: (model, resp, options) =>
        view.showError(model, resp)

  getModel: ->
    throw new Error("Need to implement getModel function")

  _getAllowedValuesForFields: (model) ->
    fieldNames = @getFieldNames()
    Promise.all(_.map(fieldNames, model.getAllowedValues, model)).then (avs...) =>
      _.reduce(avs, (result, av, index) ->
        result[fieldNames[index]] = av
        result
      , {})

  _saveLocal: (view, updates) ->
    @getModel().set(updates)

  _saveRemote: (view, updates, opts) ->
    @getModel().save updates,
      shallowFetch: @getFieldNames()
      patch: true
      success: (model, resp, options) =>
        opts?.success?(model, resp, options)
      error: (model, resp, options) =>
        opts?.error?(model, resp, options)
        @trigger('error', model, resp)
    @trigger 'change'