define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class Task extends Model
    typePath: 'task'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'

    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

    defaults:
      "State": "Defined"

    allowedValueFields: ['State']
