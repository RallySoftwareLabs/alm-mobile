Collection = require './collection'
UserStory = require './user_story'

module.exports = Collection.extend(
  url: '/slm/webservice/2.x/hierarchicalrequirement'
	model: UserStory
)