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

    render: ->
      super
      $('body').addClass('login-body')

    dispose: ->
      $('body').removeClass('login-body')    
      super

    signIn: (event) ->
      this.$('.alert').hide()
      username = this.$('#username')[0]
      password = this.$('#password')[0]
      checkbox = this.$('#remember-me')[0]
      @trigger 'submit', username, password, checkbox
      event.preventDefault()
