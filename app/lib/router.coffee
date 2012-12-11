application = require('application')

module.exports = Backbone.Router.extend
  routes:
    '': 'login'
  home: ->
    $('body').html(application.homeView.render().el)
  login: ->
    $('body').html(application.loginView.render().el)
