define [
  'hbsTemplate'
  'application'
  'views/view'
  'collections/users'
], (hbs, app, View, Users) ->

  class LoginView extends View
    template: hbs['login/templates/login']
    events:
      'click .sign-in': 'signIn'
      'touchstart .sign-in': 'signIn'
      'submit form': 'signIn'

    afterRender: ->
      $('body').addClass('login')

    remove: ->
      $('body').removeClass('login')    
      super

    signIn: (event) ->
      this.$('.alert').hide()
      username = this.$('#username')[0]
      password = this.$('#password')[0]
      checkbox = this.$('#remember-me')[0]
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
          app.fetchUserInfo ->
            app.router.navigate(app.afterLogin, {trigger: true, replace: true})
        error: (xhr, errorType, error) =>
          alert = @$('.alert').html('The password you have entered is incorrect.').show()
      )
      event.preventDefault()
