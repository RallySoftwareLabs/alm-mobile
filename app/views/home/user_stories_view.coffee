View = require '../view'
template = require './templates/user_stories'

module.exports = View.extend

  id: 'user-stories-view'
  template: template
  getRenderData: ->
    # error: @options.error
    stories: @model.toJSON()