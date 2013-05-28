define [
  'application'
  'views/view'
  'models/user_collection'
], (app, View, UserCollection) ->

  class LoginView extends View
    template: JST['login/templates/login']
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
          app.session.load()
          new UserCollection().fetch
            params:
              query: "(UserName = \"#{data.username}\")"
            success: (collection, response, options) =>
              @options.session.setUser collection.at(0)
              app.router.navigate(app.afterLogin, {trigger: true, replace: true})
            failure: ->
              debugger
        error: (xhr, errorType, error) =>
          alert = @$('.alert').html('The password you have entered is incorrect.').show()
      )
      event.preventDefault()
