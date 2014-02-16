define ->
  $ = require 'jquery'
  _ = require 'underscore'
  RallyMetrics = require 'rallymetrics'
  React = require 'react'
  Messageable = require 'lib/messageable'
  MetricsHandler = require 'lib/metrics_handler'
  User = require 'models/user'
  Session = require 'models/session'
  Router = require 'router'

  class Application

    _.extend @prototype, Messageable

    initialize: ->

      @aggregator = new RallyMetrics.Aggregator
        flushInterval: 10000
        beaconUrl: "https://trust.f4tech.com/beacon/"
        handlers: [MetricsHandler]

      @aggregator.startSession 'Mobile App Init', slug: Backbone.history.location.pathname

      @aggregator.recordAction component: this, description: 'authentication'

      React.initializeTouchEvents true

      @session = new Session(this, @aggregator)
      @afterLogin = ''
      @session.authenticated (authenticated) =>

        # @initRouter routes, pushState: false, root: '/subdir/'
        Router.initialize aggregator: @aggregator

        # Actually start routing.
        Backbone.history.start pushState: true
        
        hash = Backbone.history.fragment
        if authenticated
          if hash == 'login'
            @publishEvent 'router:route', ''
          @session.initSessionForUser()
        else
          unless _.contains(['login', 'logout', 'labsNotice'], hash)
            @afterLogin = hash
            @publishEvent 'router:route', 'logout'

        # Freeze the application instance to prevent further changes.
        Object.freeze? this

  new Application