define ->
  _ = require 'underscore'
  Model = require 'models/base/model'
  AllowedValuesMixin = require 'models/base/allowed_values_mixin'

  class Task extends Model
    typePath: 'task'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'

    _.extend this, AllowedValuesMixin.static
    _.extend @prototype, AllowedValuesMixin.prototype

    defaults:
      "State": "Defined"

    allowedValueFields: ['State']
