define ->
  $ = require 'jquery'
  _ = require 'underscore'
  RallyMetrics = require 'rallymetrics'
  React = require 'react'
  appConfig = require 'appConfig'
  Messageable = require 'lib/messageable'
  MetricsHandler = require 'lib/metrics_handler'
  User = require 'models/user'
  Session = require 'models/session'
  Router = require 'router'

  hideURLbar = -> window.scrollTo(0, 1)

  fixIE10 = ($) ->
    if navigator.userAgent.match /IEMobile\/10\.0/
      $('head').append '<style>@-ms-viewport{width:auto!important}</style>'

  class Application

    _.extend @prototype, Messageable

    initialize: ->

      setTimeout(hideURLbar, 0)
      fixIE10($)

      beaconUrl = if appConfig.almWebServiceBaseUrl == "https://rally1.rallydev.com/slm"
        "https://rust.f4tech.com/beacon/"
      else
        "https://trust.f4tech.com/beacon/"
      @aggregator = new RallyMetrics.Aggregator
        flushInterval: 10000
        beaconUrl: beaconUrl
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
          hash = '' if hash == 'login'
          @publishEvent 'router:route', hash, replace: true
        else
          unless _.contains(['login', 'logout', 'labsNotice'], hash)
            @afterLogin = hash
            @publishEvent 'router:route', 'logout'

        # Freeze the application instance to prevent further changes.
        Object.freeze? this

  new Application