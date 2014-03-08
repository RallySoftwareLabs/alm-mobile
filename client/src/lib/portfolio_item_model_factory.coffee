define ->
  app = require 'application'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  PortfolioItem = require 'models/portfolio_item'
  PortfolioItems = require 'collections/portfolio_items'
  TypeDefinitions = require 'collections/type_definitions'

# The shame about this approach is that we fetch the types every 
# time we ask for a model.  We really should just load them once.
# and keep them around somewhere

  class PortfolioItemModelFactory
    @getCollection: (ordinal) =>
      @fetchTypes().then =>
        typePath = @piTypeDefinitions.findWhere({Ordinal: ordinal}).get('ElementName')
        PortfolioItems.extend
          url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/' + typePath
          model: @_buildModel(typePath)

    @getModel: (ordinal) =>
      @fetchTypes().then =>
        typePath = @piTypeDefinitions.findWhere({Ordinal: ordinal}).get('ElementName')
        @_buildModel(typePath)

    @_buildModel: (typePath) =>
      MyModel = PortfolioItem.extend 
        urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/' + typePath
        typePath: typePath

    @fetchTypes: =>
        @piTypeDefinitions = new TypeDefinitions()
        @piTypeDefinitions.fetchAllPages
          data:
            fetch: 'ElementName,Ordinal'
            query: '(Parent.Name = "Portfolio Item")'
            order: 'Ordinal'