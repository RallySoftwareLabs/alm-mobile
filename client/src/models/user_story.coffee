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
      return 'completed' if this.isCompleted() 
      return 'scheduled' if this.isScheduled()  
      return 'unscheduled'

    isCompleted: ->
      return true if this.get('ScheduleState') == 'Accepted'  
      return true if this.get('ScheduleState') == 'Released' 
      false

    isScheduled: ->
      this.get('Release') or this.get('Iteration')