appConfig = require 'app_config'
Collection = require 'collections/collection'
AttributeDefinition = require 'models/attribute_definition'

module.exports = class AttributeDefinitions extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
  model: AttributeDefinition