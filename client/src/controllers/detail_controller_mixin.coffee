app = require 'application'
utils = require 'lib/utils'
LoadingIndicatorView = require 'views/loading_indicator'

module.exports = {
  homeRoute: '/board'

  fetchModelAndShowView: (Model, View, id) ->
    @renderReactComponent LoadingIndicatorView, region: 'main', shared: false
    fieldNames = @getFieldNames()
    model = new Model(_refObjectUUID: id)
    model.clientMetricsParent = this
    model.fetch(
      data:
        shallowFetch: fieldNames.join ','
    ).then =>
      @_getAllowedValuesForFields(model).then (allowedValues) =>
        @_setTitle model
        @renderReactComponent View, model: model, region: 'main', fieldNames: fieldNames, allowedValues: allowedValues
        @markFinished()

    @subscribeEvent 'saveField', @saveField

  showCreateView: (Model, View, defaultValues = {}) ->
    model = new Model _.defaults(defaultValues, Project: app.session.get('project').get('_ref'))
    model.clientMetricsParent = this
    @_getAllowedValuesForFields(model).then (allowedValues) =>
      @renderReactComponent View, model: model, region: 'main', allowedValues: allowedValues
      @subscribeEvent 'saveField', @saveField
      @subscribeEvent 'save', @saveNew
      @subscribeEvent 'cancel', @cancelNew
      @markFinished()
      model

  saveField: (view, updates, opts) ->
    if view.props.model.get('_ref')
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

  cancelNew: ->
    @publishEvent 'router:route', @homeRoute, replace: false

  _getAllowedValuesForFields: (model) ->
    fieldNames = @getFieldNames()
    $.when.apply($, _.map(fieldNames, model.getAllowedValues, model)).then (avs...) =>
      _.reduce(avs, (result, av, index) ->
        result[fieldNames[index]] = av
        result
      , {})

  _saveLocal: (view, updates) ->
    view.props.model.set(updates)

  _saveRemote: (view, updates, opts) ->
    view.props.model.save updates,
      shallowFetch: @getFieldNames().join ','
      wait: true
      patch: true
      success: (model, resp, options) =>
        opts?.success?(model, resp, options)
      error: (model, resp, options) =>
        opts?.error?(model, resp, options)
        view.showError(model, resp)

  _setTitle: (model) ->
    @updateTitle "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"
}