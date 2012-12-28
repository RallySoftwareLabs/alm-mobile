View = require '../view'
template = require './templates/defects'
LoadingMaskView = require '../shared/loading_view'

module.exports = View.extend

  el: '#defects-view'
  template: template

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    defects: @model.toJSON()