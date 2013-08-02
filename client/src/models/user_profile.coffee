define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class UserProfile extends Model
    typePath: 'userprofile'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/userprofile'
