appConfig = require 'app_config'
Collection = require 'collections/collection'
Discussion = require 'models/discussion'

module.exports = class Discussions extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/conversationpost'
  model: Discussion
