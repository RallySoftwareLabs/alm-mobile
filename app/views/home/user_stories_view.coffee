View = require '../view'
template = require './templates/user_stories'
app = require 'application'

module.exports = View.extend

  el: '#userstory-view'
  template: template

  getRenderData: ->
    # error: @options.error
    stories: @model.toJSON()

  addUserStory: ->
    app.router.navigate 'new/userstory', {trigger: true, replace: true}