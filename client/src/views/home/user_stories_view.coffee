define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  CollectionView = require 'views/base/collection_view'
  UserStoryView = require 'views/home/user_story_view'

  class UserStoriesView extends CollectionView

    className: "btn-group btn-group-vertical"
    itemView: UserStoryView

    addUserStory: ->
      @publishEvent '!router:routeByName', 'user_story_detail#create', replace: true