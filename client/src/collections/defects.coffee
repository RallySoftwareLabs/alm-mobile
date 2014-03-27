appConfig = require 'app_config'
Collection = require 'collections/collection'
Defect = require 'models/defect'

module.exports = class Defects extends Collection
  url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/defect'
  model: Defect