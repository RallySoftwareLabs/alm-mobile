Collection = require './collection'
UserStory = require './user_story'

module.exports = Collection.extend(
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirements'
  model: UserStory
)