define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Task = require 'models/task'

  class Tasks extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/task'
    model: Task