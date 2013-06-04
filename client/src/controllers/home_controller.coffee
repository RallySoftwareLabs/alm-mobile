define [
	'controllers/base/site_controller'
	'views/home/home_view'
], (SiteController, HomeView) ->
  class HomeController extends SiteController
    show: (params) ->
      @redirectToRoute 'home#userstories', replace: true

    userstories: (params) ->
      @view = new HomeView autoRender: true, tab: 'userstories'

    defects: (params) ->
      @view = new HomeView autoRender: true, tab: 'defects'
      
    tasks: (params) ->
      @view = new HomeView autoRender: true, tab: 'tasks'
      