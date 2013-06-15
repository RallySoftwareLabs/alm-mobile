define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Task = require 'models/task'

  class Tasks extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'
    model: Task