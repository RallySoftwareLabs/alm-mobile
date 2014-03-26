appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class AttributeDefinition extends Model
  typePath: 'attributedefinition'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'