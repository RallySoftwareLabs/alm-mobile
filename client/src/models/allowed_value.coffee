define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class AllowedValue extends Model
    typePath: 'allowedvalue'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
    