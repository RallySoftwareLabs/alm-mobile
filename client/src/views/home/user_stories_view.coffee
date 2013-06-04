define [
  'hbsTemplate'
  'application'
  'views/base/collection_view'
  'views/home/user_story_view'
], (hbs, app, CollectionView, UserStoryView) ->

  class UserStoriesView extends CollectionView

    className: "btn-group btn-group-vertical"
    itemView: UserStoryView

    addUserStory: ->
      @publishEvent '!router:routeByName', 'user_story_detail#create', replace: true