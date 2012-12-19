Collection = require './collection'
Task = require './task'

module.exports = Collection.extend
  url: 'http://mparrish-15mbr.f4tech.com/slm/webservice/2.x/tasks'
  model: Task