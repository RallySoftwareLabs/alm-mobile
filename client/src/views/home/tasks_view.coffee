define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  CollectionView = require 'views/base/collection_view'
  TaskView = require 'views/home/task_view'

  class UserStoriesView extends CollectionView

    className: "btn-group btn-group-vertical"
    itemView: TaskView
    events:
      'click #add-task' : 'addTask'

    addTask: ->
      @publishEvent '!router:routeByName', 'task_detail#create', replace: true