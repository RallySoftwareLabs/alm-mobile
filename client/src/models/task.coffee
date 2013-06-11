define ->
  Model = require 'models/base/model'

  class Task extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'

    defaults:
      "State": "Defined"

    allowedValues:
    	State: [
        'Defined',
        'In-Progress',
        'Completed'
      ]