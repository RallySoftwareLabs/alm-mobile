appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Workspace extends Model
  typePath: 'workspace'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/workspace'

  fetchDefault: (cb) ->
    @fetch
      data:
        shallowFetch: 'Name,WorkspaceConfiguration[TaskUnitName]'