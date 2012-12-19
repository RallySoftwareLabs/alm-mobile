# Application bootstrapper.
Application =
  initialize: ->
    Router = require('lib/router')
    Session = require('models/authentication')

    # Ideally, initialized classes should be kept in controllers & mediator.
    # If you're making big webapp, here's more sophisticated skeleton
    # https://github.com/paulmillr/brunch-with-chaplin

    @router = new Router()
    @session = new Session()
    Object.freeze?(@)

module.exports = Application
