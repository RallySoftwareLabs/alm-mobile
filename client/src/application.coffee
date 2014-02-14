define ->
  $ = require 'jquery'
  _ = require 'underscore'
  Messageable = require 'lib/messageable'
  React = require 'react'
  User = require 'models/user'
  Session = require 'models/session'
  Router = require 'router'

  class Application

    _.extend @prototype, Messageable

    initialize: ->

      React.initializeTouchEvents true

      @session = new Session()
      @afterLogin = ''
      @session.authenticated (authenticated) =>

        # @initRouter routes, pushState: false, root: '/subdir/'
        Router.initialize()

        # Actually start routing.
        Backbone.history.start pushState: true
        
        hash = Backbone.history.fragment
        if authenticated
          if hash == 'login'
            @publishEvent 'router:route', ''
        else
          unless _.contains(['login', 'logout', 'labsNotice'], hash)
            @afterLogin = hash
            @publishEvent 'router:route', 'logout'

        # Freeze the application instance to prevent further changes.
        Object.freeze? this

  new Application