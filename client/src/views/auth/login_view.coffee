define [
  'hbsTemplate'
  'application'
  'views/base/view'
  'collections/users'
], (hbs, app, View, Users) ->

  class LoginView extends View
    autoRender: true
    container: 'body'
    id: 'login'
    template: hbs['auth/templates/login']
    events:
      'click .sign-in': 'signIn'
      'touchstart .sign-in': 'signIn'
      'submit form': 'signIn'

    getTemplateData: ->
      currentYear: new Date().getFullYear()

    afterRender: ->
      $('body').addClass('login-body')
      if window.loginError
        @$('.alert').html(window.loginError).show()
        delete window.loginError

    dispose: ->
      $('body').removeClass('login-body')    
      super

    signIn: (event) ->
      @$('.alert').hide()
      username = @$('#username')[0].value
      password = @$('#password')[0].value
      rememberme = @$('#remember-me')[0]?.checked
      @trigger 'submit', username, password, rememberme
      event.preventDefault()

    showError: (error) ->
      @$('#password').html('')
      @$('.alert').html(error).show()
