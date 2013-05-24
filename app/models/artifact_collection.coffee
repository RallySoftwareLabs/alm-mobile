Collection = require './collection'
Artifact = require './artifact'

module.exports = Collection.extend(
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
  model: Artifact
)