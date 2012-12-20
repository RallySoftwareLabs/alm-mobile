Collection = require './collection'
UserStory = require './user_story'

module.exports = Collection.extend(
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/hierarchicalrequirements'
  model: UserStory
)