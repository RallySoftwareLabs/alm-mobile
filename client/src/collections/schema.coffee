define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  TypeDefinition = require 'models/type_definition'

  class Schema extends Collection
    typePath: '__schema__'
    url: appConfig.almWebServiceBaseUrl + '/schema/v2.x/project'
    model: TypeDefinition