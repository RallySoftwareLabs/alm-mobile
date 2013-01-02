Collection = require './collection'
Artifact = require './artifact'

module.exports = Collection.extend(
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/artifacts'
  model: Artifact
)