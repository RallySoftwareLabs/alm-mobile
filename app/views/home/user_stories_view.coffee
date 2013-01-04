View = require '../view'
template = require './templates/user_stories'
LoadingMaskView = require '../shared/loading_view'
app = require 'application'

module.exports = View.extend

  el: '#userstory-view'
  template: template

  renderLoadingMask: ->
    mask = new LoadingMaskView()
    mask.setElement(@el)
    mask.render()

  getRenderData: ->
    # error: @options.error
    stories: @model.toJSON()

  addUserStory: ->
    app.router.navigate 'new/userstory', {trigger: true, replace: true}