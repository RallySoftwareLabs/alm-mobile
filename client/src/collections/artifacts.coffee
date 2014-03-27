appConfig = require 'app_config'
Collection = require 'collections/collection'
Artifact = require 'models/artifact'

module.exports = class Artifacts extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/artifact'
  model: Artifact
