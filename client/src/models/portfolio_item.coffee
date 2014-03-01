define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class PortfolioItem extends Model
    typePath: 'portfolioitem'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
    

   