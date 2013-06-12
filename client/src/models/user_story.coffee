define ->
  _ = require 'underscore'
  Model = require 'models/base/model'
  AllowedValuesMixin = require 'models/base/allowed_values_mixin'

  class UserStory extends Model
    typePath: 'hierarchicalrequirement'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirement'
    
    _.extend this, AllowedValuesMixin.static
    _.extend @prototype, AllowedValuesMixin.prototype

    defaults:
      "ScheduleState" : "Defined"
    
    allowedValueFields: ['ScheduleState', 'c_KanbanState']
      