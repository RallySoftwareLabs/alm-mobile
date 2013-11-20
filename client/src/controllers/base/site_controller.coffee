define ->
  Controller = require 'controllers/base/controller'
  SiteView = require 'views/site'
  HeaderView = require 'views/header'
  NavigationView = require 'views/navigation/navigation'

  composeReactView = (@view) ->
    @view.renderForChaplin()

  class SiteController extends Controller
    beforeAction: (params, route) ->
      @compose 'site', -> composeReactView SiteView()
      @compose 'header', -> composeReactView HeaderView(region: 'header')
      @compose 'navigation', -> composeReactView NavigationView(region: 'navigation')
