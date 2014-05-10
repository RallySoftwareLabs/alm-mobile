Promise = require('es6-promise').Promise
appConfig = require 'app_config'
PortfolioItem = require 'models/portfolio_item'
PortfolioItems = require 'collections/portfolio_items'
TypeDefinitions = require 'collections/type_definitions'

# The shame about this approach is that we fetch the types every 
# time we ask for a model.  We really should just load them once.
# and keep them around somewhere

module.exports = {
  getCollection: (ordinal) ->
    @fetchTypes().then (piTypeDefinitions) =>
      typeDef = @lookupTypeDef(ordinal, piTypeDefinitions)
      typePath = typeDef.get('TypePath')
      model = @_buildModel(typeDef)
      PortfolioItems.extend
        url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/' + typePath.toLowerCase()
        model: model
        typePath: typePath
        name: model.prototype.name

  getModel: (ordinal) ->
    @fetchTypes().then (piTypeDefinitions) =>
      @_buildModel @lookupTypeDef ordinal, piTypeDefinitions

  _buildModel: (typeDef) ->
    typePath = typeDef.get('TypePath')
    MyModel = PortfolioItem.extend 
      urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/' + typePath.toLowerCase()
      typePath: typePath
      name: typeDef.get('Name')
  
  lookupTypeDef: (ordinal, typeDefinitions) ->
    typeDefinitions.findWhere({Ordinal: ordinal})

  fetchTypes: ->
    if @piTypeDefinitions
      return @piTypeDefinitions
      
    piTypeDefinitions = new TypeDefinitions()
    @piTypeDefinitions = piTypeDefinitions.fetchAllPages(
      data:
        fetch: 'Name,TypePath,Ordinal'
        query: '(Parent.Name = "Portfolio Item")'
        order: 'Ordinal'
    )

  clear: -> @piTypeDefinitions = null

}