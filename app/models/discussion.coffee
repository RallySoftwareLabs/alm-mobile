Model = require 'models/model'

module.exports = class Discussion extends Model
  urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/conversationpost'
