define ->
  Chaplin = require 'chaplin'
  React = require 'react'
  app = require 'application'
  InitializingView = require 'views/initializing'

  class Controller extends Chaplin.Controller
      
    whenLoggedIn: (callback) ->
      if app.session.get('project')?
        @goToPage callback
      else
        @view = @renderReactComponent InitializingView, region: 'main', shared: false
        @subscribeEvent 'projectready', @onProjectReady(callback)

    onProjectReady: (callback) ->
      func = => 
        @unsubscribeEvent 'projectready', func
        @view.dispose()
        @goToPage callback

    goToPage: (callback) ->
      if app.session.hasAcceptedLabsNotice()
        callback?.apply this
      else
        setTimeout =>
          @redirectToRoute 'auth#labsNotice'
        , 0

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    renderReactComponent: (componentClass, props = {}, id) ->
      if this.constructor.sharedView && props.shared != false

        if this.constructor.sharedView.instance?
          this.constructor.sharedView.instance.setProps props
          return

        component = this.constructor.sharedView.instance = componentClass(props)
      else
        component = componentClass(props)

      component.renderForChaplin id

  Controller._maybeDisposeView = (currentController, params, route, options) ->
    if this.sharedView?.instance? && currentController.constructor != this
      this.sharedView.instance.dispose()
      this.sharedView.instance = null

  Controller.reuseViewAcrossControllerActions = ->
    Chaplin.mediator.subscribe 'dispatcher:dispatch', this._maybeDisposeView, this
    this.sharedView = { instance: null }

  Controller