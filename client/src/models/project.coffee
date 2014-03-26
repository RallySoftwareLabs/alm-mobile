appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class Project extends Model
  typePath: 'project'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project'
