appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Artifact extends Model
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/artifact'
