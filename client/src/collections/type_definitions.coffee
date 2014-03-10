define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  TypeDefinition = require 'models/type_definition'

  class TypeDefinitions extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/typedefinition'
    model: TypeDefinition