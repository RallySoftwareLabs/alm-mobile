define ->
  Model = require 'models/base/model'

  class Defect extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defect'

    defaults:
      "State" : "Open"

    allowedValues:
      ScheduleState: ['Defined', 'In-Progress', 'Completed', 'Accepted']
      State: ['Submitted', 'Open', 'Fixed', 'Closed']
      Priority: ['None', 'Resolve Immediately', 'High Attention', 'Normal', 'Low']
      Severity: ['None', 'Crash/Data Loss', 'Major Problem', 'Minor Problem', 'Cosmetic']
      c_KanbanState: ['Ready', 'Test Planning', 'Building', 'Ready to Toggle On', 'Released']