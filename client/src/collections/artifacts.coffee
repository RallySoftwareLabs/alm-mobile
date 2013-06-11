define ->
  Collection = require 'collections/collection'
  Artifact = require 'models/artifact'

  class Artifacts extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
    model: Artifact
