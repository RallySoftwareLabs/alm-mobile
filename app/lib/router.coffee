app = require 'application'
UserStoryCollection = require '../models/user_story_collection'
UserStory = require '../models/user_story'
HomeView = require '../views/home_view'
UserStoryDetailView = require '../views/user_story_detail_view'

module.exports = Backbone.Router.extend({
  routes:
    'login': 'login'
    '': 'home'
    'userstory/:id': 'userStoryDetail'

  home: ->
    if !app.session.authenticated()
      @.navigate('login', {trigger: true, replace: true})
      return

    userStoryCollection = new UserStoryCollection
    homeView = new HomeView
      model: userStoryCollection
      loading: true
    $('#content').html(homeView.render().el)

    userStoryCollection.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
      success: (collection, response, options) ->
        homeView.loading = false
        $('#content').html(homeView.render().el)
      failure: (collection, xhr, options) ->
        homeView.loading = false
        $('#content').html(homeView.render().el)
    })

  userStoryDetail: (oid) ->
    if !app.session.authenticated()
      @.navigate('login', {trigger: true, replace: true})
      return

    userStoryCollection = new UserStoryCollection()
    userStoryCollection.fetch({
      data:
        fetch: ['ObjectID', 'FormattedID', 'Name', 'ScheduleState'].join ','
        query: "( OID = \"#{oid}\" )"
      success: (collection, response, options) -> 
        view = new UserStoryDetailView(model: collection.at(0))
        $('#content').html(view.render().el)
    })

  login: ->
    $('#content').html(app.loginView.render().el)
})