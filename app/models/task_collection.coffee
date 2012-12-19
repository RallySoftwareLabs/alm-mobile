Collection = require './collection'
Task = require './task'

module.exports = Collection.extend
  url: 'http://snappa.f4tech.com/slm/webservice/2.x/tasks'
  model: Task