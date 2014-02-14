define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'
  UserStory = require 'models/user_story'

  class PortfolioItem extends Model
    typePath: 'portfolioitem'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem'
    
    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

   