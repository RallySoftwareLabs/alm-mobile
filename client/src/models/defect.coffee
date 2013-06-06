define [
  'models/base/model'
], (Model) ->

  class Defect extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defects'

    defaults:
      "State" : "Open"

    allowedValues:
    	ScheduleState: ['Defined', 'In-Progress', 'Completed', 'Accepted']
    	State: ['Submitted', 'Open', 'Fixed', 'Closed']