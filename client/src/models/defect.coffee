define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Defect extends Model
    typePath: 'defect'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/defect'

    defaults:
      "State" : "Submitted"
      "ScheduleState": "Idea"

    allowedValueFields: [
      'Iteration'
      'Priority'
      'Project'
      'Release'
      'ScheduleState'
      'Severity'
      'State'
      'c_KanbanState'
    ]
