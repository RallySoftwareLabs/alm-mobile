View = require '../view'
template = require './templates/login'
app = require '../../application'

module.exports = View.extend
  el: '#content'
  template: template
  events:
    'click .sign-in': 'signIn'

  afterRender: ->
    $('body').addClass('login')

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
      success: (data, status, xhr) ->
        $('body').removeClass('login')
        app.session.load()
        Backbone.history.navigate(app.afterLogin, {trigger: true})
      error: (xhr, errorType, error) =>
        alert = this.$('.alert').html('The password you have entered is incorrect.').show()
    )
    event.preventDefault()
