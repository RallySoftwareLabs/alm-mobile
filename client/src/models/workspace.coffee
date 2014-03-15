define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Workspace extends Model
    typePath: 'workspace'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/workspace'

    fetchDefault: (cb) ->
      @fetch
        data:
          shallowFetch: 'Name,WorkspaceConfiguration[TaskUnitName]'