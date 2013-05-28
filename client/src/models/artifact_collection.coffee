define ['models/collection', 'models/artifact'], (Collection, Artifact) ->

  Collection.extend(
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
    model: Artifact
  )