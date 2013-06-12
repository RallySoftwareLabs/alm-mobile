define ->
  Model = require 'models/base/model'

  class Project extends Model
    typePath: 'project'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/project'
