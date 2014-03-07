define ->
  app = require 'application'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  PortfolioItem = require 'models/portfolio_item'
  PortfolioItems = require 'collections/portfolio_items'
  TypeDefinitions = require 'collections/type_definitions'

  class PortfolioItemModelFactory
    @getCollectionModel: (ordinal) =>
      piTypesFetchPromise = @fetchPortfolioItemTypes()
      piTypesFetchPromise.then =>
        elementName = @piTypeDefinitions.findWhere({Ordinal: ordinal}).get('ElementName')
        PortfolioItems.extend
          url: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/' + elementName
          model: @getPortfolioItemModel(elementName)
        

    @getPortfolioItemModel: (elementName) =>
      MyModel = PortfolioItem.extend 
        urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/' + elementName
        typePath: elementName

    @fetchPortfolioItemTypes: =>
        @piTypeDefinitions = new TypeDefinitions()
        @piTypeDefinitions.fetchAllPages
          data:
            fetch: 'ElementName,Ordinal'
            query: '(Parent.Name = "Portfolio Item")'
            order: 'Ordinal'