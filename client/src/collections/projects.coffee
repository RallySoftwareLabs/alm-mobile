appConfig = require 'app_config'
Collection = require 'collections/collection'
Project = require 'models/project'

module.exports = class Projects extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project'
  model: Project

  projects: null

  @fetchAll: ->
    if @::projects
      d = $.Deferred()
      d.resolve @::projects
      d.promise()
    else
      @::projects = projects = new Projects()
      projects.fetchAllPages(
        data:
          shallowFetch: 'Name,Parent,Workspace,SchemaVersion'
          order: 'Name'
      )
