define ->
  _ = require 'underscore'
  app = require 'application'
  appConfig = require 'appConfig'
  SiteController = require 'controllers/base/site_controller'
  WallView = require 'views/wall/wall'
  Initiatives = require 'collections/initiatives'
  Initiative = require 'models/initiative'
  Features = require 'collections/features'
  UserStories = require 'collections/user_stories'

  class WallController extends SiteController
    index: (params) ->
      @updateTitle "Enterprise Backlog"

      @initiatives = new Initiatives()
      @initiatives.clientMetricsParent = this

      @features = new Features()
      @features.clientMetricsParent = this

      @userStories = new UserStories()
      @userStories.clientMetricsParent = this

      @view = @renderReactComponent WallView, model: @initiatives, region: 'main'
      @subscribeEvent 'cardclick', @onCardClick

      hardcodedRandDProjectRef = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project/334329159'#12271

      initiativesAndFeaturesPromise = $.when(
        @fetchInitiatives(hardcodedRandDProjectRef)
        @fetchFeatures(hardcodedRandDProjectRef)
      )
      userStoriesFetchPromise = @fetchUserStories(hardcodedRandDProjectRef)        
      
      initiativesAndFeaturesPromise.then =>
        if @initiatives.isEmpty()
          @markFinished()
        else
          @features.each (f) =>
            parentRef = f.get('Parent')._ref
            initiative = @initiatives.find _.isAttributeEqual('_ref', parentRef)

            if initiative?
              initiative.features ?= new Features()
              initiative.features.add f
          
          @initiatives.trigger('add')

          userStoriesFetchPromise.then =>
            @userStories.each (us) =>
              parentRef = us.get('PortfolioItem')._ref
              feature = @features.find _.isAttributeEqual('_ref', parentRef)

              if feature?
                feature.userStories ?= new UserStories()
                feature.userStories.add us

            @initiatives.trigger('add')
            @markFinished()

    fetchInitiatives: (projectRef) ->
      @initiatives.fetchAllPages
        data:
          fetch: 'FormattedID,Name'
          query: '(State.Name = "Building")'
          order: 'Rank ASC'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    fetchFeatures: (projectRef) ->
      @features.fetchAllPages
        data:
          fetch: 'Parent',
          query: "(Parent != null)",
          order: 'Rank ASC'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    fetchUserStories: (projectRef) ->
      @userStories.fetchAllPages
        data: 
          fetch: 'Release,Iteration,PortfolioItem',
          query: "(PortfolioItem != null)",
          order: 'Rank ASC'
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    onCardClick: (oid, type) ->
      app.aggregator.recordAction component: this, description: "clicked wall card"
      mappedType = 'portfolioitem'
      @redirectTo "#{mappedType}/#{oid}"
