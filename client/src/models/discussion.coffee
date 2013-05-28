define ['models/model'], (Model) ->

  class Discussion extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
