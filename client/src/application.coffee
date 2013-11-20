define ->
  $ = require 'jquery'
  _ = require 'underscore'
  Chaplin = require 'chaplin'
  React = require 'react'
  User = require 'models/user'
  Session = require 'models/session'
  routes = require 'routes'

  class Application extends Chaplin.Application
    title: 'Rally ALM Mobile'

    initialize: ->
      super

      React.initializeTouchEvents true

      @session = new Session()
      @afterLogin = ''
      @session.authenticated (authenticated) =>

        # @initRouter routes, pushState: false, root: '/subdir/'
        @initRouter routes

        # Dispatcher listens for routing events and initialises controllers.
        @initDispatcher controllerSuffix: '_controller'

        # Layout listens for click events & delegates internal links to router.
        @initLayout()

        # Composer grants the ability for views and stuff to be persisted.
        @initComposer()

        # Mediator is a global message broker which implements pub / sub pattern.
        @initMediator()

        # Actually start routing.
        @startRouting()
        
        hash = Backbone.history.fragment
        if authenticated
          if hash == 'login'
            @publishEvent '!router:route', ''
        else
          unless _.contains(['login', 'logout', 'labsNotice'], hash)
            @afterLogin = hash
            @publishEvent '!router:route', 'logout'

        # Freeze the application instance to prevent further changes.
        Object.freeze? this

    initLayout: ->
      @layout = new Chaplin.Layout {@title}

    # Create additional mediator properties.
    initMediator: ->
      # Add additional application-specific properties and methods
      # e.g. Chaplin.mediator.prop = null
      Chaplin.mediator.user = null
      # Seal the mediator.
      Chaplin.mediator.seal()

  new Application