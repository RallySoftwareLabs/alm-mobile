define ->
  Application = 
    initialize: (Router, User, Session) ->

      # Ideally, initialized classes should be kept in controllers & mediator.
      # If you're making big webapp, here's more sophisticated skeleton
      # https://github.com/paulmillr/brunch-with-chaplin

      @session = new Session()
      @router = new Router(this)
      @afterLogin = 'home'

      if @session.authenticated()
        u = new User()
        u.fetch
          url: "#{u.urlRoot}:current"
          params:
            fetch: 'ObjectID,DisplayName'
          success: (model, response, opts) =>
            @session.setUser model
      else
        hash = Backbone.history.getHash()
        @afterLogin = hash unless hash = '#login'
      
      Object.freeze? this
