define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  SchemaMixin = require 'models/base/schema_mixin'

  class Defect extends Model
    typePath: 'defect'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/defect'

    _.extend this, SchemaMixin.static
    _.extend @prototype, SchemaMixin.prototype

    defaults:
      "State" : "Open"

    allowedValueFields: ['ScheduleState', 'State', 'Priority', 'Severity', 'c_KanbanState']
