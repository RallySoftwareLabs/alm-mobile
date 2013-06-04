define [
	'controllers/base/site_controller'
	'views/navigation/navigation_view'
], (SiteController, NavigationView) ->
	class NavigationController extends SiteController

		show: (params) ->
			@view = new NavigationView region: 'main'