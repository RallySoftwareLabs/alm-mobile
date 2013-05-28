define [
  'application'
  'views/view'
], (app, View) ->

  View.extend

    el: '#task-view'
    template: JST['home/templates/tasks']
    events:
      'click #add-task' : 'addTask'

    getRenderData: ->
      # error: @options.error
      tasks: @model.toJSON()

    addTask: ->
      app.router.navigate 'new/task', {trigger: true, replace: true}