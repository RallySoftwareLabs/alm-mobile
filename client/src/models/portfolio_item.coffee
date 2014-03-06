define ->
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  Model = require 'models/base/model'

  class PortfolioItem extends Model
    typePath: 'portfolioitem'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
    
    fetch: (config) ->
      super(config).then (fetchPromise) =>
        ref = @get('_ref')
        if ref
          @typePath = utils.getTypeFromRef(ref)

        fetchPromise

    constructor: (typeDef) ->
      this.typePath = typeDef.get('ElementName')
      this.urlRoot = appConfig.almWebServiceBaseUrl + '/webService@@WSAPI_VERSION/' + this.typePath
   