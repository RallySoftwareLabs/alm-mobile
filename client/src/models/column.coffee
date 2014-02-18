define ->
  $ = require 'jquery'
  Model = require 'models/base/model'
  Artifacts = require 'collections/artifacts'

  class Column extends Model

    constructor: ->
      super
      @artifacts = new Artifacts()

    fetch: (data) ->
      @artifacts.clientMetricsParent = this
      $.when(
        @artifacts.fetch(data: data)
      ).done (a) =>
        @setSynced true
        @trigger 'sync', this, a, data: data
