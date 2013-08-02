define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Iteration = require 'models/iteration'

  class Iterations extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/iteration'
    model: Iteration
