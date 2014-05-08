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

  @clearCache: ->
    @::projects = null

  @getIdsWithinScopeDown: (rootProject) ->
    @fetchAll().then =>
      parentChildHash = @::projects.reduce (acc, p) ->
        uuid = p.get('_refObjectUUID')
        parentUuid = p.get('Parent')?._refObjectUUID
        return acc unless parentUuid

        if !acc[parentUuid]
          acc[parentUuid] = []
        acc[parentUuid].push(uuid)
        acc
      , {}

      searchDown = (projectsInScope, currentUuid) =>
        projectsInScope.push currentUuid
        _.each(parentChildHash[currentUuid], _.partial(searchDown, projectsInScope))
        projectsInScope

      searchDown([], rootProject.get('_refObjectUUID'))
      