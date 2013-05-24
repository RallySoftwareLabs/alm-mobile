Collection = require './collection'
Task = require './task'

module.exports = Collection.extend
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/tasks'
  model: Task