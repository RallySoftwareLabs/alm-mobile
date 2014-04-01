appConfig = require 'app_config'
Collection = require 'collections/collection'
UserStory = require 'models/user_story'

module.exports = class UserStories extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
  model: UserStory
  typePath: 'hierarchicalrequirement'

  areAllStoriesScheduled: ->
    return false if @isEmpty()
    
    this.every (userStory) ->
      userStory.isScheduled()
