define [
	'views/home/home_view'
	'views/home/user_stories_view'
], (HomeView, UserStoriesView) ->

	class UserStoriesPageView extends HomeView
		listView: UserStoriesView
		createRoute: 'new/userstory'
