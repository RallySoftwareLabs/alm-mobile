define ->
  Collection = require 'collections/collection'
  User = require 'models/user'

  class Users extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/users'
    model: User