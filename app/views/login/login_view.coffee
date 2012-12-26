View = require 'views/view'
template = require './templates/login'
UserCollection = require 'models/user_collection'
app = require 'application'

module.exports = class LoginView extends View
  template: template
  events:
    'click .sign-in': 'signIn'

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
        app.session.load()
        new UserCollection().fetch
          params:
            query: "(UserName = \"#{data.username}\")"
          success: (collection, response, options) =>
            @options.session.setUser collection.at(0)
            Backbone.history.navigate(app.afterLogin, {trigger: true})
          failure: ->
            debugger
      error: (xhr, errorType, error) ->
        alert = this.$('.alert').html('The password you have entered is incorrect.').show()
    )
    event.preventDefault()
