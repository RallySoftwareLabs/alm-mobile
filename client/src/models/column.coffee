define ->
  $ = require 'jquery'
  Chaplin = require 'chaplin'
  Model = require 'models/base/model'
  Artifacts = require 'collections/artifacts'

  class Column extends Model

    _.extend @prototype, Chaplin.SyncMachine

    constructor: ->
      super
      @artifacts = new Artifacts()

    fetch: (data) ->
      #Set the machine into `syncing` state
      @beginSync()

      $.when(
        @artifacts.fetch(data: data)
      ).done (a) =>
        # Set the machine into `synced` state
        @finishSync()
        @trigger 'change', this
