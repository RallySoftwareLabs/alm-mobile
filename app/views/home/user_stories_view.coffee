View = require '../view'
template = require './templates/user_stories'

module.exports = View.extend

  el: '#user-stories-view'
  template: template
  getRenderData: ->
    # error: @options.error
    stories: @model.toJSON()