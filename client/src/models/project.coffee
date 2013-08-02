define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Project extends Model
    typePath: 'project'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project'
