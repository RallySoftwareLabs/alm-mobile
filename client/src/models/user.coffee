define ->
  Model = require 'models/base/model'

  class User extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/user'