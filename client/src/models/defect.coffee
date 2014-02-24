define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class Defect extends Model
    typePath: 'defect'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/defect'

    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

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
