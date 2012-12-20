Model = require 'models/model'

module.exports = Model.extend
  urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/users'