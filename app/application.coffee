User = require 'models/user'

# Application bootstrapper.
Application =
  initialize: ->
    Router = require('lib/router')
    Session = require('models/authentication')

    # Ideally, initialized classes should be kept in controllers & mediator.
    # If you're making big webapp, here's more sophisticated skeleton
    # https://github.com/paulmillr/brunch-with-chaplin

    @session = new Session()
    @router = new Router()
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
      @afterLogin = Backbone.history.getHash()
    
    Object.freeze? this

module.exports = Application
