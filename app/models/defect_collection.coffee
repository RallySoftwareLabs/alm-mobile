Collection = require './collection'
Defect = require './defect'

module.exports = Collection.extend
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/v2.x/defects'
  model: Defect