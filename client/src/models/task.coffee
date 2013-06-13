define ->
  _ = require 'underscore'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class Task extends Model
    typePath: 'task'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'

    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

    defaults:
      "State": "Defined"

    allowedValueFields: ['State']
