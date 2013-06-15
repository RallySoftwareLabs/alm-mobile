define ->
  Chaplin = require 'chaplin'
  app = require 'application'
  Controller = require 'controllers/base/controller'
  LoginView = require 'views/auth/login_view'

  class AuthController extends Controller

    logout: (params) ->
      app.session.logout()
      @redirectToRoute 'auth#login'

    login: (params) ->
      @view = new LoginView
      @listenTo @view, 'submit', @onSubmit

    onSubmit: (username, password, rememberme) ->
      app.session.authenticate username, password, (authenticated) =>
        if err?
          app.session.logout()
          @view.showError 'There was an error signing in. Please try again.'
        else
          if authenticated
            @redirectTo app.afterLogin, replace: true
          else
            app.session.logout()
            @view.showError 'The password you have entered is incorrect.'
