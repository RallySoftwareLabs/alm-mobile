define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Project = require 'models/project'

  class Projects extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project'
    model: Project
