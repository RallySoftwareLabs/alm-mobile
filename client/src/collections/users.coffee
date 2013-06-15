define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  User = require 'models/user'

  class Users extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/user'
    model: User