appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class UserProfile extends Model
  typePath: 'userprofile'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/userprofile'
