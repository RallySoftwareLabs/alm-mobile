define ->
  Model = require 'models/base/model'

  class Artifact extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifact'
