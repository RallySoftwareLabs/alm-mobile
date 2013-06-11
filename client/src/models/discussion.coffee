define ->
  Model = require 'models/base/model'

  class Discussion extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
