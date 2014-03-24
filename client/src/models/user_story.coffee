define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class UserStory extends Model
    typePath: 'hierarchicalrequirement'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
    
    defaults:
      "ScheduleState" : "Idea"
    
    allowedValueFields: ['Iteration', 'Release', 'ScheduleState', 'c_KanbanState']
