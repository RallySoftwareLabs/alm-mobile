define ->
  Collection = require 'collections/collection'
  Project = require 'models/project'

  class Projects extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/project'
    model: Project
