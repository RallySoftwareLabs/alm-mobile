View = require '../view'
template = require './templates/user_stories'
LoadingMaskView = require '../shared/loading_view'

module.exports = View.extend

  el: '#user-stories-view'
  template: template

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    stories: @model.toJSON()