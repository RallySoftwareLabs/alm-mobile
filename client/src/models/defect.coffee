_ = require 'underscore'
appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Defect extends Model
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
