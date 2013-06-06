define [
	'views/home/home_view'
	'views/home/tasks_view'
], (HomeView, TasksView) ->

	class TasksPageView extends HomeView
		listView: TasksView
		createRoute: 'new/task'
