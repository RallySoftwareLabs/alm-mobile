define ->
  _ = require 'underscore'
  app = require 'application'
  appConfig = require 'appConfig'
  SiteController = require 'controllers/base/site_controller'
  WallView = require 'views/wall/wall'
  Initiatives = require 'collections/initiatives'
  Initiative = require 'models/initiative'
  Features = require 'collections/features'

  class WallController extends SiteController
    index: (params) ->
      @whenLoggedIn =>
        initiatives = new Initiatives()
        @fetchInitiatives initiatives
        @view = @renderReactComponent WallView, model: initiatives, region: 'main'
    fetchInitiatives: (initiatives) ->
      hardcodedRandDProjectRef = appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/project/334329159'
      initiatives.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,Children'
          query: '(State.Name = "Building")'
          order: 'Rank ASC'
          project: hardcodedRandDProjectRef
          projectScopeUp: false
          projectScopeDown: true
        success: (initiatives) =>
          @fetchFeatures initiative for initiative in initiatives.models;
    fetchFeatures: (initiative) ->
      initiative.features = new Features()
      parentRef = initiative.attributes._ref
      initiative.features.fetch
        data:
          fetch: 'FormattedID,Name,ObjectID,Owner,LeafStoryCount',
          query: "(Parent = " + parentRef + ")",
          order: 'Rank ASC'
        success: (initiative, features) =>
          this.view.forceUpdate()
  