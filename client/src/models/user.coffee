define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class User extends Model
    typePath: 'user'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/user'