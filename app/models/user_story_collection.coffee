Collection = require './collection'
UserStory = require './user_story'

module.exports = Collection.extend(
	model: UserStory
)