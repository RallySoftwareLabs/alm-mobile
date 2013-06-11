define ->
  Collection = require 'collections/collection'
  Discussion = require 'models/discussion'

  class Discussions extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
    model: Discussion
