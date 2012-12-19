Collection = require './collection'
Defect = require './defect'

module.exports = Collection.extend
  url: 'http://snappa.f4tech.com/slm/webservice/2.x/defects'
  model: Defect