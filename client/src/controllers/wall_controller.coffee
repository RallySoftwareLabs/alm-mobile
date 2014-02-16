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
      @whenLoggedIn =>
        @updateTitle "Enterprise Backlog"
        initiatives = new Initiatives()
        initiatives.clientMetricsParent = this
        @view = @renderReactComponent WallView, model: initiatives, region: 'main'
        @subscribeEvent 'cardclick', @onCardClick
        @fetchInitiatives initiatives
    fetchInitiatives: (initiatives) ->
      hardcodedRandDProjectRef = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project/12271'#334329159'
      initiatives.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,Children'
          query: '(State.Name = "Building")'
          order: 'Rank ASC'
          project: hardcodedRandDProjectRef
          projectScopeUp: false
          projectScopeDown: true
        success: (initiatives) =>
          if initiatives.isEmpty()
            @markFinished()
          else
            $.when.apply($, initiatives.map(@fetchFeatures, this)).always =>
              @markFinished()

    fetchFeatures: (initiative) ->
      deferred = $.Deferred()
      initiative.features = new Features()
      initiative.features.clientMetricsParent = this
      parentRef = initiative.attributes._ref
      initiative.features.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,LeafStoryCount',
          query: "(Parent = " + parentRef + ")",
          order: 'Rank ASC'
        success: (features) =>
          this.view.forceUpdate()
          if features.isEmpty()
            deferred.resolve()
          else
            $.when.apply($, features.map(@fetchUserStories, this)).always =>
              deferred.resolve()

      deferred.promise()

    fetchUserStories: (feature) ->
      deferred = $.Deferred()
      feature.userStories = new UserStories()
      feature.userStories.clientMetricsParent = this
      parentRef = feature.attributes._ref
      feature.userStories.fetch
        data: 
          fetch: 'FormattedID,Name,Release,Iteration',
          query: "(PortfolioItem = " + parentRef + ")",
          order: 'Rank ASC'
        success:  =>
          this.view.forceUpdate()
          deferred.resolve()
      
      deferred.promise()

    onCardClick: (oid, type) ->
      app.aggregator.recordAction component: this, description: "clicked wall card"
      mappedType = 'portfolioitem'
      @redirectTo "#{mappedType}/#{oid}"
