define ->
  _ = require 'underscore'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  WallView = require 'views/wall/wall'

  class WallController extends SiteController
    index: (params) ->
      @whenLoggedIn =>
        @view = @renderReactComponent WallView, params, region: 'main'   