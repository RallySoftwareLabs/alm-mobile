define [
  'models/base/model'
], (Model) ->

  class Artifact extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/artifacts'
