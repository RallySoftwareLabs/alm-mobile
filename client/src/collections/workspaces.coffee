Promise = require('es6-promise').Promise
appConfig = require 'app_config'
Collection = require 'collections/collection'
Workspace = require 'models/workspace'

module.exports = class Workspaces extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/workspace'
  model: Workspace

  workspaces: null

  @fetchAll: ->
    if @::workspaces
      Promise.resolve @::workspaces
    else
      @::workspaces = workspaces = new Workspaces()
      workspaces.fetchAllPages(
        data:
          shallowFetch: 'Name,Workspace,SchemaVersion'
          order: 'Name'
      )
