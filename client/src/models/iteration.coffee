define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Iteration extends Model
    typePath: 'iteration'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/iteration'
