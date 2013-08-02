define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  User = require 'models/user'

  class Users extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/user'
    model: User