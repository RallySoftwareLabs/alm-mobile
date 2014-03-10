define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class UserStory extends Model
    typePath: 'hierarchicalrequirement'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/hierarchicalrequirement'
    
    defaults:
      "ScheduleState" : "Idea"
    
    allowedValueFields: ['Iteration', 'Release', 'ScheduleState', 'c_KanbanState']

    planStatus: ->
      return 'completed' if @isCompleted() 
      return 'scheduled' if @isScheduled()  
      return 'unscheduled'

    isCompleted: ->
      @get('ScheduleState') is 'Accepted' or @get('ScheduleState') is 'Released' 
      
    isScheduled: ->
      @get('Release') or @get('Iteration')