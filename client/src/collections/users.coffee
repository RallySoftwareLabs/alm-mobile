appConfig = require 'app_config'
Collection = require 'collections/collection'
User = require 'models/user'

module.exports = class Users extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/user'
  model: User