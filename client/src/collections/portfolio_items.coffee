define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  PortfolioItem = require 'models/portfolio_item'

  class PortfolioItems extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
    model: PortfolioItem