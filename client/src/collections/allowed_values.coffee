define ->
  Collection = require 'collections/collection'

  class AllowedValues extends Collection
    url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/attributedefinition'
    