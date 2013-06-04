define [
	'controllers/base/site_controller'
	'views/settings/settings_view'
], (SiteController, SettingsView) ->
	class NavigationController extends SiteController

		show: (params) ->
			@view = new SettingsView region: 'main'