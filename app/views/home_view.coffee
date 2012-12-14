View = require('./view')
template = require('./templates/home')
UserStory = require '../models/user_story'

module.exports = View.extend
  id: 'home-view'
  template: template
  getRenderData: ->
  	stories: @model.toJSON()

