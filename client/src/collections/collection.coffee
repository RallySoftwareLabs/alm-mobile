define ->
  _ = require 'underscore'
  Backbone = require 'backbone'
  Messageable = require 'lib/messageable'

  # Base class for all collections.
  class Collection extends Backbone.Collection

    _.extend @prototype, Messageable

    constructor: ->
      super
      @synced = false
      this.once('sync', => @synced = true)

    parse: (resp) ->
      resp.QueryResult.Results

    isSynced: -> @synced

    setSynced: (@synced) ->
