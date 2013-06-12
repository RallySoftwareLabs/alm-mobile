define ->
  Model = require 'models/base/model'

  class UserProfile extends Model
    typePath: 'userprofile'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/userprofile'
