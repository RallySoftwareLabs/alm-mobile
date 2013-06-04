define [
  'chaplin'
  'application'
  'controllers/base/controller'
  'views/auth/login_view'
], (Chaplin, app, Controller, LoginView) ->
  class AuthController extends Controller
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
          app.session.setSecurityToken data.securityToken
          if app.session.hasSessionCookie()
            app.fetchUserInfo =>
              @redirectTo app.afterLogin, replace: true
        error: (xhr, errorType, error) =>
          alert = @$('.alert').html('The password you have entered is incorrect.').show()
      )
