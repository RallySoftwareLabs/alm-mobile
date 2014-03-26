appConfig = require 'app_config'
Collection = require 'collections/collection'
Task = require 'models/task'

module.exports = class Tasks extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/task'
  model: Task