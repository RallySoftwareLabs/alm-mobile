app = require 'application'
# required models
UserStory = require 'models/user_story'

# required views
LoginView = require 'views/login/login_view'
HomeView = require 'views/home/home_view'
UserStoryDetailView = require 'views/detail/user_story_detail_view'

module.exports = Backbone.Router.extend({
  routes:
    'login': 'login'
    '': 'home'
    'userstory/:id': 'userStoryDetail'

  home: ->
    if !app.session.authenticated()
      @.navigate('login', {trigger: true, replace: true})
      return

    homeView = new HomeView().load()

  userStoryDetail: (oid) ->
    if !app.session.authenticated()
      @.navigate('login', {trigger: true, replace: true})
      return

    view = new UserStoryDetailView(oid: oid, autoRender: true, el: $('#content'))

  login: ->
    loginView = new LoginView()
    $('#content').html(loginView.render().el)
})