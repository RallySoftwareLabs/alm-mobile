define ->
  _ = require 'underscore'
  Model = require 'models/base/model'
  AllowedValuesMixin = require 'models/base/allowed_values_mixin'

  class Defect extends Model
    typePath: 'defect'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defect'

    _.extend this, AllowedValuesMixin.static
    _.extend @prototype, AllowedValuesMixin.prototype

    defaults:
      "State" : "Open"

    allowedValueFields: ['ScheduleState', 'State', 'Priority', 'Severity', 'c_KanbanState']
