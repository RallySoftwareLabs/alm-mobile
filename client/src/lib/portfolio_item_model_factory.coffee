define ->
  app = require 'application'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  PortfolioItems = require 'collections/portfolio_items'
  TypeDefinitions = require 'collections/type_definitions'

  class PortfolioItemModelFactory
    @getCollectionModel: (ordinal) ->
      piTypesFetchPromise = @fetchPortfolioItemTypes()
      piTypesFetchPromise.then =>
        elementName = @piTypeDefinitions.findWhere({Ordinal: ordinal}).get('ElementName')
        portfolioItems = new PortfolioItems();
        portfolioItems.url = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/portfolioitem/' + elementName
        portfolioItems
      
    @fetchPortfolioItemTypes: ->
        @piTypeDefinitions = new TypeDefinitions()
        @piTypeDefinitions.fetchAllPages
          data:
            fetch: 'ElementName,Ordinal'
            query: '(Parent.Name = "Portfolio Item")'
            order: 'Ordinal'