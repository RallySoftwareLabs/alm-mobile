appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class UserStory extends Model
  typePath: 'hierarchicalrequirement'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
  
  defaults:
    "ScheduleState" : "Idea"
  
  allowedValueFields: ['Iteration', 'Release', 'ScheduleState', 'c_KanbanState']
