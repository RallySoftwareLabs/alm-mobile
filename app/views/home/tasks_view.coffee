View = require '../view'
template = require './templates/tasks'
app = require 'application'

module.exports = View.extend

  el: '#task-view'
  template: template
  events:
    'click #add-task' : 'addTask'

  getRenderData: ->
    # error: @options.error
    tasks: @model.toJSON()

  addTask: ->
    app.router.navigate 'new/task', {trigger: true, replace: true}