appConfig = require 'app_config'
Collection = require 'collections/collection'

module.exports = class AllowedValues extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
  