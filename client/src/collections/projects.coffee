define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  Project = require 'models/project'

  class Projects extends Collection
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
            fetch: 'Name,Workspace,SchemaVersion'
            order: 'Name'
        )
