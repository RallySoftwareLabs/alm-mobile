View = require('./view')
template = require('./templates/user_story_detail')
UserStory = require '../models/user_story'

module.exports = View.extend
  id: 'user-story-detail-view'
  template: template
  getRenderData: ->
    @model.toJSON()
