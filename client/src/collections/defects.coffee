define ->
  Collection = require 'collections/collection'
  Defect = require 'models/defect'

  class Defects extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defect'
    model: Defect