define ->
  Model = require 'models/base/model'

  class User extends Model
    typePath: 'user'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/user'