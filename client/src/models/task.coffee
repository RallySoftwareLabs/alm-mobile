define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Task extends Model
    typePath: 'task'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/task'

    defaults:
      "State": "Defined"

    allowedValueFields: ['State']
