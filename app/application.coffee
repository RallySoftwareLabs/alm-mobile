# Application bootstrapper.
Application =
  initialize: ->
    Router = require('lib/router')
    Session = require('models/authentication')

    # Ideally, initialized classes should be kept in controllers & mediator.
    # If you're making big webapp, here's more sophisticated skeleton
    # https://github.com/paulmillr/brunch-with-chaplin

    @session = new Session()
    @afterLogin = ''

    unless @session.authenticated()
      @afterLogin = Backbone.history.getHash()
      Backbone.history._updateHash Backbone.history.location, 'login', true

    @router = new Router()
    Object.freeze?(@)

module.exports = Application
