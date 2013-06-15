define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'
  AttributeDefinition = require 'models/attributedefinition'

  class AttributeDefinitions extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'
    model: AttributeDefinition