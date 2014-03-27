appConfig = require 'app_config'
Model = require 'models/base/model'

module.exports = class AllowedValue extends Model
  typePath: 'allowedvalue'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
  