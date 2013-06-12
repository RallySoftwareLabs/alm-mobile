define ->
  Model = require 'models/base/model'

  class AttributeDefinition extends Model
    typePath: 'attributedefinition'
    urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'