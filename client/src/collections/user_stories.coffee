define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  UserStory = require 'models/user_story'

  class UserStories extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
    model: UserStory

    areAllStoriesScheduled: ->
      return false if @isEmpty()
      
      this.every (userStory) ->
        userStory.isScheduled()
