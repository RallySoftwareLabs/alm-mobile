define ->
  Model = require 'models/base/model'

  class Project extends Model
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/project'
