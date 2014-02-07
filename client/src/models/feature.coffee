define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'
  UserStory = require 'models/user_story'

  class Feature extends Model
    typePath: 'portfolioitem/feature'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/feature'
    
    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

   