define ->
  _ = require 'underscore'
  Chaplin = require 'chaplin'

  # Base class for all collections.
  class Collection extends Chaplin.Collection

    _.extend @prototype, Chaplin.SyncMachine

    parse: (resp) ->
      resp.QueryResult.Results

    fetch: (options) ->
      @beginSync()

      $.when(
        super
      ).done (c) =>
        @finishSync()
