appConfig = require 'app_config'
Collection = require 'collections/collection'
Workspace = require 'models/workspace'

module.exports = class Workspaces extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/workspace'
  model: Workspace

  workspaces: null

  @fetchAll: ->
    if @::workspaces
      d = $.Deferred()
      d.resolve @::workspaces
      d.promise()
    else
      @::workspaces = workspaces = new Workspaces()
      workspaces.fetchAllPages(
        data:
          shallowFetch: 'Name,Workspace,SchemaVersion'
          order: 'Name'
      )
