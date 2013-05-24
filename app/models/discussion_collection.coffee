Collection = require './collection'
Discussion = require './discussion'

module.exports = class DiscussionCollection extends Collection
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
  model: Discussion
