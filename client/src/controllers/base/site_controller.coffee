define ->
  Controller = require 'controllers/base/controller'
  NavigationController = require 'controllers/navigation_controller'
  SiteView = require 'views/site_view'
  HeaderView = require 'views/header_view'
  NavigationView = require 'views/navigation/navigation_view'

  class SiteController extends Controller
    beforeAction: (params, route) ->
      @compose 'site', SiteView
      @compose 'header', HeaderView
      @compose 'navigation',
        compose: ->
          @controller = new NavigationController
          @view = @controller.view

        check: -> false
      # @compose 'auth', ->
      #   SessionController = require 'controllers/session_controller'
      #   @controller = new SessionController

      # if route.name in ['users#show', 'repos#show', 'topics#show']
      #   @compose 'navigation', ->
      #     @model = new Navigation
      #     @view = new NavigationView {@model}