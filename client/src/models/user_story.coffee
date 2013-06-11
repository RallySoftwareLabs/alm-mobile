define ->
  Model = require 'models/base/model'

  class UserStory extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/hierarchicalrequirement'
    
    defaults:
      "ScheduleState" : "Defined"
    
    allowedValues:
      ScheduleState: ['Defined', 'In-Progress', 'Completed', 'Accepted']
      c_KanbanState: ['Ready', 'Test Planning', 'Building', 'Ready to Toggle On', 'Released']
