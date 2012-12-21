Collection = require './collection'
Project = require './project'

module.exports = class ProjectCollection extends Collection
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/project'
  model: Project
