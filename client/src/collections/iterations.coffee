define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Iteration = require 'models/iteration'

  class Iterations extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/iteration'
    model: Iteration
