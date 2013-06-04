define [
  'hbsTemplate'
  'application'
  'views/base/collection_view'
  'views/home/task_view'
], (hbs, app, CollectionView, TaskView) ->

  class UserStoriesView extends CollectionView

    className: "btn-group btn-group-vertical"
    itemView: TaskView
    events:
      'click #add-task' : 'addTask'

    addTask: ->
      @publishEvent '!router:routeByName', 'task_detail#create', replace: true