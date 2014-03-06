define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  PortfolioItem = require 'models/portfolio_item'

  class PortfolioItems extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
    model: PortfolioItem

   	constructor: (typeDef) ->
      this.typePath = typeDef.get('ElementName')
      this.urlRoot = appConfig.almWebServiceBaseUrl + '/webService@@WSAPI_VERSION/' + this.typePath
   