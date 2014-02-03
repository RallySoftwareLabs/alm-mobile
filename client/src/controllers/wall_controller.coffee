define ->
  _ = require 'underscore'
  app = require 'application'
  appConfig = require 'appConfig'
  SiteController = require 'controllers/base/site_controller'
  WallView = require 'views/wall/wall'
  Initiatives = require 'collections/initiatives'

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
          fetch: 'FormattedID,Name,ObjectID,Owner'
          query: '(State.Name = "Building")'
          order: 'Rank ASC'
          project: hardcodedRandDProjectRef
          projectScopeUp: false
          projectScopeDown: true
      
