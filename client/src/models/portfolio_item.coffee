appConfig = require 'app_config'
utils = require 'lib/utils'
Model = require 'models/base/model'

module.exports = class PortfolioItem extends Model
  typePath: 'portfolioitem'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
  
  fetch: (config) ->
    super(config).then (fetchPromise) =>
      ref = @get('_ref')
      if ref
        @typePath = utils.getTypeFromRef(ref)

      fetchPromise
 