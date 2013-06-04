define [
  'controllers/base/controller'
  'views/site_view'
  'views/header_view'
], (Controller, SiteView, HeaderView) ->
# Navigation = require 'models/navigation'
# NavigationView = require 'views/navigation-view'

  class SiteController extends Controller
    beforeAction: (params, route) ->
      @compose 'site', SiteView
      @compose 'header', HeaderView
      # @compose 'auth', ->
      #   SessionController = require 'controllers/session_controller'
      #   @controller = new SessionController

      # if route.name in ['users#show', 'repos#show', 'topics#show']
      #   @compose 'navigation', ->
      #     @model = new Navigation
      #     @view = new NavigationView {@model}