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

      hardcodedRandDProjectRef = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project/12271'#334329159'

      $.when(
        @fetchInitiatives(hardcodedRandDProjectRef)
        @fetchFeatures(hardcodedRandDProjectRef)
        @fetchUserStories(hardcodedRandDProjectRef)
      ).then =>
        unless @initiatives.isEmpty()
          @features.each (f) =>
            parentRef = f.get('Parent')._ref
            initiative = @initiatives.find _.isAttributeEqual('_ref', parentRef)

            if initiative?
              initiative.features ?= new Features()
              initiative.features.add f

          @userStories.each (us) =>
            parentRef = us.get('PortfolioItem')._ref
            feature = @features.find _.isAttributeEqual('_ref', parentRef)

            if feature?
              feature.userStories ?= new UserStories()
              feature.userStories.add us

        @initiatives.trigger('add')
        @markFinished()

    fetchInitiatives: (projectRef) ->
      @initiatives.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,Children'
          query: '(State.Name = "Building")'
          order: 'Rank ASC'
          pagesize: 200
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    fetchFeatures: (projectRef) ->
      @features.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,LeafStoryCount,Parent',
          query: "(Parent != null)",
          order: 'Rank ASC'
          pagesize: 200
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    fetchUserStories: (projectRef) ->
      
      # start = @pagesize + 1
      # projectFetches = while totalCount >= start
      #   fetch = projects.fetch(
      #     remove: false
      #     data:
      #       fetch: 'Name,SchemaVersion'
      #       start: start
      #       pagesize: @pagesize
      #       order: 'Name'
      #   )
      #   start += @pagesize
      #   fetch

      # $.when.apply($, projectFetches).always =>
      #   @aggregator.endLoad component: this
      @userStories.fetch
        data: 
          fetch: 'FormattedID,Name,Release,Iteration,PortfolioItem',
          query: "(PortfolioItem != null)",
          order: 'Rank ASC'
          pagesize: 200
          project: projectRef
          projectScopeUp: false
          projectScopeDown: true

    onCardClick: (oid, type) ->
      app.aggregator.recordAction component: this, description: "clicked wall card"
      mappedType = 'portfolioitem'
      @redirectTo "#{mappedType}/#{oid}"
