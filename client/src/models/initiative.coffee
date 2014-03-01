define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Initiative extends Model
    typePath: 'portfolioitem/initiative'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/initiative'

    allowedValueFields: ['State']
