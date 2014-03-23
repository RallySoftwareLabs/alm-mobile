define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class User extends Model
    typePath: 'user'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/user'

    fetchSelf: (cb) ->
      @fetch
        data:
          fetch: 'DisplayName,UserProfile,DefaultProject,DefaultWorkspace,WorkspaceConfiguration,TaskUnitName,Subscription,SubscriptionID'
        success: (model, resp, opts) =>
          cb?(null, model)
        error: (model, resp, options) =>
          cb?('auth', model)
