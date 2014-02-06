define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Feature = require 'models/feature'

  class Features extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/feature'
    model: Feature
