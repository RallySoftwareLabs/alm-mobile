define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class UserStory extends Model
    typePath: 'hierarchicalrequirement'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
    
    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

    defaults:
      "ScheduleState" : "Idea"
    
    allowedValueFields: ['ScheduleState', 'c_KanbanState']

    isScheduled: ->
      this.get('Release') or this.get('Iteration')
      