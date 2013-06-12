define ->
  Collection = require 'collections/collection'
  Task = require 'models/task'

  class Tasks extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/task'
    model: Task