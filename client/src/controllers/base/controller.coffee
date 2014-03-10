define ->
  Backbone = require 'backbone'
  React = require 'react'
  app = require 'application'
  appConfig = require 'appConfig'
  Messageable = require 'lib/messageable'
  Projects = require 'collections/projects'
  LoadingIndicatorView = require 'views/loading_indicator'

  class Controller

    _.extend @prototype, Messageable
      
    whenProjectIsLoaded: (options) ->
      if _.isFunction(options)
        callback = options
      else
        callback = options.fn
        projectRef = "#{appConfig.almWebServiceBaseUrl}/webservice/@@WSAPI_VERSION/project/#{options.project}"

      sessionProject = app.session.get('project')
      if sessionProject?
        if !projectRef || _.contains(sessionProject.get('_ref'), projectRef)
          @_goToPage callback
        else
          project = Projects::projects.find _.isAttributeEqual '_ref', projectRef
          @_renderLoadingIndicatorUntilProjectIsReady(callback, options.showLoadingIndicator)
          app.session.set 'project', project
      else
        @_renderLoadingIndicatorUntilProjectIsReady(callback, options.showLoadingIndicator)
        app.session.initSessionForUser(projectRef)

    _onProjectReady: (callback) ->
      func = => 
        @_goToPage callback

    _goToPage: (callback) ->
      if app.session.hasAcceptedLabsNotice()
        callback?.apply this
      else
        setTimeout =>
          @markFinished()
          @redirectTo 'labsNotice'
        , 1

    _renderLoadingIndicatorUntilProjectIsReady: (callback, showLoadingIndicator) ->
      if showLoadingIndicator != false
        @view = @renderReactComponent LoadingIndicatorView, region: 'main', text: 'Initializing'
      @subscribeEventOnce 'projectready', @_onProjectReady(callback)

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    redirectTo: (path, params) ->
      @publishEvent "router:route", path

    markFinished: ->
      @trigger 'controllerfinished', this

    renderReactComponent: (componentClass, props = {}, id) ->
      component = componentClass(_.omit(props, 'region'))

      component.renderForBackbone id

      component

    dispose: ->
      @stopListening()
      @unsubscribeAllEvents()


