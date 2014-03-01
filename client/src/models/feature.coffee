define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Feature extends Model
    typePath: 'portfolioitem/feature'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/feature'

   