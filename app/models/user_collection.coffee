Collection = require 'models/collection'

module.exports = class UserCollection extends Collection
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/users'