define ->
  $ = require 'jquery'
  Chaplin = require 'chaplin'
  Model = require 'models/base/model'
  UserStories= require 'collections/user_stories'
  Defects = require 'collections/defects'
  Artifacts = require 'collections/artifacts'

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
        @trigger 'change', this

    artifacts: ->
      new Artifacts @stories.models.concat(@defects.models)
