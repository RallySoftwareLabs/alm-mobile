define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Artifact = require 'models/artifact'

  class Artifacts extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifact'
    model: Artifact
