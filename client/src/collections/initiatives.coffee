define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Initiative = require 'models/initiative'

  class Initiatives extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/initiative'
    model: Initiative
