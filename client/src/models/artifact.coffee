define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Artifact extends Model
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/artifact'
