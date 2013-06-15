define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  UserStory = require 'models/user_story'

  class UserStories extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirement'
    model: UserStory
