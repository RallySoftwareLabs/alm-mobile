app = require 'application'
# required models
UserStory = require 'models/user_story'

# required views
LoginView = require '../views/login/login_view'
HomeView = require 'views/home/home_view'
UserStoryDetailView = require 'views/user_story_detail_view'

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

    userStoryCollection = new UserStoryCollection()
    userStoryCollection.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'Owner', 'Tags', 'Project', 'Description', 'Iteration', 'Release', 'ScheduleState'].join ','
        query: "( OID = \"#{oid}\" )"
      success: (collection, response, options) ->
        view = new UserStoryDetailView(model: collection.at(0))
        $('#content').html(view.render().el)
    })

  login: ->
    loginView = new LoginView()
    $('#content').html(loginView.render().el)
})