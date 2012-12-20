Collection = require './collection'
Defect = require './defect'

module.exports = Collection.extend
  url: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/defects'
  model: Defect