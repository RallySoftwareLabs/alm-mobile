Model = require 'models/model'

module.exports = Model.extend
  urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
