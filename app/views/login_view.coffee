View = require('./view')
template = require('./templates/login')

module.exports = View.extend
  id: 'login-view'
  template: template
  events:
    'click .sign-in': 'signIn'

  signIn: (event) ->
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
        rememberme: checkbox.checked
      success: (data, status, xhr) ->
        Backbone.history.navigate('', {trigger: true})
      error: (xhr, errorType, error) ->
        this.$('.control-group').addClass('error')
    )

    event.preventDefault()
