define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'

  class AllowedValues extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/attributedefinition'
    