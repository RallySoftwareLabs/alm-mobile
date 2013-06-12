define ->
  Model = require 'models/base/model'

  class AllowedValue extends Model
    typePath: 'allowedvalue'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'
    