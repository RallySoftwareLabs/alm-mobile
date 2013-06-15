define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Artifact extends Model
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifact'
