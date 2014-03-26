_ = require 'underscore'
Backbone = require 'backbone'
FetchAllPagesMixin = require 'lib/fetch_all_pages_mixin'
Messageable = require 'lib/messageable'

# Base class for all collections.
module.exports = class Collection extends Backbone.Collection

  _.extend @prototype, Messageable
  _.extend @prototype, FetchAllPagesMixin

  constructor: ->
    super
    @synced = false
    this.once('sync', => @synced = true)

  parse: (resp) ->
    resp.QueryResult.Results

  isSynced: -> @synced

  setSynced: (@synced) ->
