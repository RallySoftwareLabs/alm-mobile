appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Iteration extends Model
  typePath: 'iteration'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/iteration'