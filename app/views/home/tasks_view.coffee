View = require '../view'
template = require './templates/tasks'

module.exports = View.extend

  el: '#tasks-view'
  template: template
  getRenderData: ->
    # error: @options.error
    tasks: @model.toJSON()