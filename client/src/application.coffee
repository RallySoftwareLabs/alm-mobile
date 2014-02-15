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

      @aggregator.recordAction component: this, description: 'mobile app init'

      React.initializeTouchEvents true

      @session = new Session(@aggregator)
      @afterLogin = ''
      @session.authenticated (authenticated) =>

        if authenticated
          @aggregator.beginLoad component: this, description: 'initializing'

        # @initRouter routes, pushState: false, root: '/subdir/'
        Router.initialize aggregator: @aggregator

        # Actually start routing.
        Backbone.history.start pushState: true
        
        hash = Backbone.history.fragment
        if authenticated
            @aggregator.endLoad component: this
          if hash == 'login'
            @publishEvent 'router:route', ''
        else
          unless _.contains(['login', 'logout', 'labsNotice'], hash)
            @afterLogin = hash
            @publishEvent 'router:route', 'logout'

        # Freeze the application instance to prevent further changes.
        Object.freeze? this

  new Application