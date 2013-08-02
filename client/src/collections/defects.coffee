define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Defect = require 'models/defect'

  class Defects extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/defect'
    model: Defect