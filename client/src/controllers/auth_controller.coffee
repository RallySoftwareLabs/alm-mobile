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

    onSubmit: (username, password, checkbox) ->
      $.ajax(
        url: Backbone.history.root + 'login'
        type: 'POST'
        dataType: 'json'
        data:
          username: username.value
          password: password.value
          # rememberme: checkbox.checked
        success: (data, status, xhr) =>
          app.session.setSecurityToken data.jsessionid, data.securityToken
          if app.session.hasSessionCookie()
            app.session.fetchUserInfo (err, user) =>
              if err?
                app.session.logout()
                @view.showError 'There was an error signing in. Please try again.'
              else
                @redirectTo app.afterLogin, replace: true
        error: (xhr, errorType, error) =>
          app.session.logout()
          @view.showError 'The password you have entered is incorrect.'
      )
