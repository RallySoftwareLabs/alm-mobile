utils = require 'lib/utils'
DiscussionCollection = require 'models/discussion_collection'
View = require 'views/view'
DiscussionTemplate = require './templates/discussion'

module.exports = class DiscussionView extends View
  
  template: DiscussionTemplate

  className: 'discussion-page'

  initialize: (config) ->
    super config
    new DiscussionCollection().fetch(
      data:
        fetch: "Text,User,Artifact,CreationDate"
        query: "(Artifact = #{utils.getRef(config.type, config.oid)})"
      success: (collection, response, options) =>
        @model = collection
        @render()
    )

  getRenderData: ->
    return {
      discussion: @model?.models || []
    }