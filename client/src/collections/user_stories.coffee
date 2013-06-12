define ->
  Collection = require 'collections/collection'
  UserStory = require 'models/user_story'

  class UserStories extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirement'
    model: UserStory
