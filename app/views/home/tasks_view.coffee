View = require '../view'
template = require './templates/tasks'
LoadingMaskView = require '../shared/loading_view'

module.exports = View.extend

  el: '#tasks-view'
  template: template

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    tasks: @model.toJSON()