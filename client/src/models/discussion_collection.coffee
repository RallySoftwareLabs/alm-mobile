define ['models/collection', 'models/discussion'], (Collection, Discussion) ->

  class DiscussionCollection extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
    model: Discussion
