define [
  'jquery'
  'models/user'
  'models/authentication'
], ($, User, Session) ->

  Application = 
    initialize: (Router, User, Session) ->

      @session = new Session()
      @router = new Router(this)
      @afterLogin = 'home'

      Backbone.history.start(
        # root: '/m'
        # pushState: true
      )

      @session.authenticated (authenticated) =>
        if authenticated
          @fetchUserInfo()
        else
          hash = Backbone.history.getHash()
          @afterLogin = hash unless hash == 'login'
          Backbone.history.navigate 'login', trigger: true, replace: true

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