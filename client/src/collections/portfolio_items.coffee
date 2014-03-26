appConfig = require 'app_config'
Collection = require 'collections/collection'
PortfolioItem = require 'models/portfolio_item'

module.exports = class PortfolioItems extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
  model: PortfolioItem