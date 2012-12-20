Collection = require './collection'
Task = require './task'

module.exports = Collection.extend
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/tasks'
  model: Task