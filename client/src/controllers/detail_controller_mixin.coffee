define ->
  app = require 'application'
  utils = require 'lib/utils'

  return {
    homeRoute: '/board'

    fetchModelAndShowView: (Model, View, id) ->
      fieldNames = @getFieldNames()
      model = new Model(ObjectID: id)
      model.fetch
        data:
          fetch: fieldNames.join ','
        success: (model, response, opts) =>
          @updateTitle "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"
      @view = @renderReactComponent View, model: model, region: 'main', fieldNames: fieldNames
      @subscribeEvent 'saveField', @saveField

    showCreateView: (Model, View, defaultValues = {}) ->
      model = new Model defaultValues
      @view = @renderReactComponent View, model: model, region: 'main', newArtifact: true
      @subscribeEvent 'saveField', @saveField
      @listenTo @view, 'save', @saveNew
      @listenTo @view, 'cancel', @cancelNew

    saveField: (updates, opts) ->
      if @view.props.newArtifact
        @_saveLocal(updates, opts)
      else
        @_saveRemote(updates, opts)

      @view.props.model.set updates

    saveNew: (model) ->
      model.set Project: app.session.get('project').get('_ref')
      model.sync 'create', model,
        fetch: ['ObjectID'].concat(@getFieldNames()).join ','
        wait: true
        patch: true
        success: (resp, status, xhr) =>
          opts?.success?(model, resp)
          @publishEvent '!router:route', utils.getDetailHash(model), replace: true
          @view.setProps newArtifact: false
        error: (resp, status, xhr) =>
          @view.showError(model, resp)

    cancelNew: ->
      @publishEvent '!router:route', @homeRoute, replace: false

    _saveLocal: (updates, opts) ->
      @view.props.model.set(updates)

    _saveRemote: (updates, opts) ->
      @view.props.model.save updates,
        fetch: ['ObjectID'].concat(@getFieldNames()).join ','
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
        error: (model, xhr, options) =>
          opts?.error?(model, xhr, options)
  }