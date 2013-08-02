define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Discussion = require 'models/discussion'

  class Discussions extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/conversationpost'
    model: Discussion
