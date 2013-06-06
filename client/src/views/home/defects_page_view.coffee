define [
	'views/home/home_view'
	'views/home/defects_view'
], (HomeView, DefectsView) ->

	class DefectsPageView extends HomeView
		listView: DefectsView
		createRoute: 'new/defect'
