define ->
  HomeView = require 'views/home/home_view'
  TasksView = require 'views/home/tasks_view'

  class TasksPageView extends HomeView
    listView: TasksView
    createRoute: 'new/task'
