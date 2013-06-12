define ->
  Collection = require 'collections/collection'
  AttributeDefinition = require 'models/attributedefinition'

  class AttributeDefinitions extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'
    model: AttributeDefinition