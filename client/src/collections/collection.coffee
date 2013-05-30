define ->

  # Base class for all collections.
  Backbone.Collection.extend
    parse: (resp) ->
      resp.QueryResult.Results
