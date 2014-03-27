appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Discussion extends Model
  typePath: 'conversationpost'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/conversationpost'
