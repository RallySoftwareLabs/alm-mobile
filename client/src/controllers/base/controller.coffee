define ->
  Backbone = require 'backbone'
  React = require 'react'
  app = require 'application'
  Messageable = require 'lib/messageable'
  LoadingIndicatorView = require 'views/loading_indicator'

  class Controller

    _.extend @prototype, Backbone.Events
    _.extend @prototype, Messageable
      
    whenLoggedIn: (callback) ->
      if app.session.get('project')?
        @goToPage callback
      else
        @view = @renderReactComponent LoadingIndicatorView, region: 'main', text: 'Initializing'
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      func = => 
        @unsubscribeEvent 'projectready', func
        # @view.dispose()
        @goToPage callback

    goToPage: (callback) ->
      if app.session.hasAcceptedLabsNotice()
        callback?.apply this
      else
        setTimeout =>
          @redirectTo 'labsNotice'
        , 0

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    redirectTo: (path, params) ->
      @publishEvent "router:route", path

    renderReactComponent: (componentClass, props = {}, id) ->
      component = componentClass(_.omit(props, 'region'))

      component.renderForBackbone id

      component

    dispose: ->
      @stopListening()
      @unsubscribeAllEvents()
