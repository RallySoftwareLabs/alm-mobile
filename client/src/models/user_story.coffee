define [
  'models/base/model'
], (Model) ->

  class UserStory extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirements'
    
    defaults:
      "ScheduleState" : "Defined"
    
    allowedValues:
    	ScheduleState: ['Defined', 'In-Progress', 'Completed', 'Accepted']
