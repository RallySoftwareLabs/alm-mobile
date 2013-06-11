define ->
  HomeView = require 'views/home/home_view'
  UserStoriesView = require 'views/home/user_stories_view'

  class UserStoriesPageView extends HomeView
    listView: UserStoriesView
    createRoute: 'new/userstory'
