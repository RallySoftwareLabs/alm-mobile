define [
  'controllers/base/controller'
  'views/site_view'
  'views/header_view'
  'views/navigation/navigation_view'
], (Controller, SiteView, HeaderView, NavigationView) ->
# Navigation = require 'models/navigation'
# NavigationView = require 'views/navigation-view'

  class SiteController extends Controller
    beforeAction: (params, route) ->
      @compose 'site', SiteView
      @compose 'header', HeaderView
      @compose 'navigation', NavigationView
      # @compose 'auth', ->
      #   SessionController = require 'controllers/session_controller'
      #   @controller = new SessionController

      # if route.name in ['users#show', 'repos#show', 'topics#show']
      #   @compose 'navigation', ->
      #     @model = new Navigation
      #     @view = new NavigationView {@model}