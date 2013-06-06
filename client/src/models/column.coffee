define [
  'jquery'
  'chaplin'
  'models/base/model'
  'collections/user_stories'
  'collections/defects'
], ($, Chaplin, Model, UserStories, Defects) ->
  class Column extends Model

    _.extend @prototype, Chaplin.SyncMachine

    constructor: ->
      super
      @stories = new UserStories()
      @defects = new Defects()

    fetch: (data) ->
      #Set the machine into `syncing` state
      @beginSync()

      $.when(
        @stories.fetch(data: data),
        @defects.fetch(data: data)
      ).done (s, d) =>
        # Set the machine into `synced` state
        @finishSync()
