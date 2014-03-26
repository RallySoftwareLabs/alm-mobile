appConfig = require 'app_config'
Collection = require 'collections/collection'
TypeDefinition = require 'models/type_definition'

module.exports = class TypeDefinitions extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/typedefinition'
  model: TypeDefinition