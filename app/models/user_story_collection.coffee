Collection = require './collection'
UserStory = require './user_story'

module.exports = Collection.extend(
  url: 'http://mparrish-15mbr.f4tech.com/slm/webservice/2.x/hierarchicalrequirement'
  model: UserStory
)