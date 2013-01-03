utils = require 'lib/utils'
app = require 'application'
DiscussionCollection = require 'models/discussion_collection'
Discussion = require 'models/discussion'
View = require 'views/view'
DiscussionListTemplate = require './templates/discussion_list'

module.exports = class DiscussionListView extends View
  
  template: DiscussionListTemplate

  initialize: (config) ->
    super config
    @model.fetch(
      data:
        fetch: "Text,User,Artifact,CreationDate"
        query: "(Artifact = #{config.artifact})"
        order: "CreationDate DESC,ObjectID"
      success: (collection, response, options) =>
        @render()
    )

  getRenderData: ->
    return {
      discussion: @model.models
    }