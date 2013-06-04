define [
  'jquery'
  'chaplin'
  'models/user'
  'models/authentication'
  'routes'
], ($, Chaplin, User, Session, routes) ->

  class Application extends Chaplin.Application
    title: 'Rally ALM Mobile'

    initialize: ->
      super

      @session = new Session()
      @afterLogin = ''
      @session.authenticated (authenticated) =>
        if authenticated
          @fetchUserInfo()
        else
          hash = Backbone.history.getHash()
          @afterLogin = hash unless hash == 'login'
          Backbone.history.navigate 'login', trigger: true, replace: true

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
        
    fetchUserInfo: (cb) ->
      u = new User()
      u.fetch
        url: "#{u.urlRoot}:current"
        params:
          fetch: 'ObjectID,DisplayName'
        success: (model, response, opts) =>
          @session.setUser model
          cb?(model)
      
      Object.freeze? this

  new Application