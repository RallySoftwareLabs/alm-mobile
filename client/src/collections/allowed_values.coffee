define ->
  appConfig = require 'appConfig'
  Collection = require 'collections/collection'

  class AllowedValues extends Collection
    url: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'
    