Promise = require('es6-promise').Promise
appConfig = require 'app_config'
Model = require 'models/base/model'
Artifacts = require 'collections/artifacts'

module.exports = class Iteration extends Model
  typePath: 'iteration'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/iteration'

  fetchScheduledItems: (fetchConfig = {}) ->
    Promise.resolve(
      if @artifacts
        @artifacts
      else
        @artifacts = new Artifacts()
        @artifacts.clientMetricsParent = this
        @artifacts.fetchAllPages
          data:
            _.assign(
              shallowFetch: 'FormattedID,Name,PlanEstimate,Blocked,PortfolioItem[FormattedID;Name]'
              types: 'hierarchicalrequirement,defect'
              query: "(Iteration = #{@get('_ref')})"
              order: 'Rank'
              project: @get('Project')?._ref
              projectScopeDown: false
            , fetchConfig
            )
    )