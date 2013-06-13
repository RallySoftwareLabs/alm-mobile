define ->
  _ = require 'underscore'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class UserStory extends Model
    typePath: 'hierarchicalrequirement'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirement'
    
    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

    defaults:
      "ScheduleState" : "Defined"
    
    allowedValueFields: ['ScheduleState', 'c_KanbanState']
      