app = require 'application'
UserStoryCollection = require '../models/user_story_collection'
UserStory = require '../models/user_story'
HomeView = require '../views/home_view'


module.exports = Backbone.Router.extend
  routes:
    '': 'login'
    'home': 'home'

  home: ->
  	userStoryCollection = new UserStoryCollection
  	homeView = new HomeView
  		model: userStoryCollection

  	userStoryCollection.on 'change', ->
  		homeView.render()


  	userStoryCollection.add([
	  	new UserStory(
	  		formattedID: 'US1'
	  		name: 'User Story 1'
	  		owner: 'matt'
	  	),
	  	new UserStory(
	  		formattedID: 'US2'
	  		name: 'User Story 2'
	  		owner: 'matt'
	  	),
	  	new UserStory(
	  		formattedID: 'US3'
	  		name: 'User Story 3'
	  		owner: 'matt'
	  	),
	  	new UserStory(
	  		formattedID: 'US4'
	  		name: 'User Story 4'
	  		owner: 'matt'
	  	)
	  ])
	  $('#content').html(homeView.render().el)
  	# userStoryCollection.fetch(
  	# 	success: ->
    #  		$('#content').html(homeView.render().el)
    # )
  login: ->
    $('#content').html(app.loginView.render().el)
