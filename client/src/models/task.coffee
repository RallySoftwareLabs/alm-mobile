appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Task extends Model
  typePath: 'task'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/task'

  defaults:
    "State": "Defined"

  allowedValueFields: ['State']
