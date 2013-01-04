View = require '../view'
template = require './templates/tasks'
LoadingMaskView = require '../shared/loading_view'
app = require 'application'

module.exports = View.extend

  el: '#task-view'
  template: template
  events:
    'click #add-task' : 'addTask'

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    tasks: @model.toJSON()

  addTask: ->
    app.router.navigate 'new/task', {trigger: true, replace: true}