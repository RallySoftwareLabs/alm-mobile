define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'
  Features = require 'collections/features'

  class Initiative extends Model
    typePath: 'portfolioitem/initiative'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/initiative'
    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype   

    initialize: ->
      features = new Features()