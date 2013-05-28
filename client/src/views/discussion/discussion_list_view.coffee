define [
  'lib/utils'
  'application'
  'views/view'
  'models/discussion'
  'models/discussion_collection'
], (utils, app, View, Discussion, DiscussionCollection) ->

  class DiscussionListView extends View
    
    template: JST['discussion/templates/discussion_list']

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
      discussion: @model.models
