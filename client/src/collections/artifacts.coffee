define ->
  Chaplin = require 'chaplin'
  Artifact = require 'models/artifact'

  class Artifacts extends Chaplin.Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
    model: Artifact
