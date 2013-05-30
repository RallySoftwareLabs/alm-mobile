define ['collections/collection', 'models/discussion'], (Collection, Discussion) ->

  class Discussions extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
    model: Discussion
