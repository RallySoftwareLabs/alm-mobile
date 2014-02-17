define ->
  Backbone = require 'backbone'
  React = require 'react'
  app = require 'application'
  Messageable = require 'lib/messageable'
  LoadingIndicatorView = require 'views/loading_indicator'

  class Controller

    _.extend @prototype, Messageable
      
    whenProjectIsLoaded: (callback) ->
      if app.session.get('project')?
        @_goToPage callback
      else
        @view = @renderReactComponent LoadingIndicatorView, region: 'main', text: 'Initializing'
        @subscribeEventOnce 'projectready', @_onProjectReady(callback)

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


