View = require('views/view')
template = require('views/templates/home')
UserStory = require 'models/user_story'

module.exports = View.extend
  id: 'home-view'
  template: template
  getRenderData: ->
    error: @options.error
    stories: @model.toJSON()

