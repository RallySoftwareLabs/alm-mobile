# Application bootstrapper.
Application =
  initialize: ->
    HomeView = require('views/home_view')
    LoginView = require('views/login_view')
    Router = require('lib/router')
    Session = require('models/authentication')

    # Ideally, initialized classes should be kept in controllers & mediator.
    # If you're making big webapp, here's more sophisticated skeleton
    # https://github.com/paulmillr/brunch-with-chaplin
    @homeView = new HomeView()
    @loginView = new LoginView()
    @router = new Router()
    @session = new Session()
    Object.freeze?(@)

module.exports = Application
