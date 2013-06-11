define ->
  Chaplin = require 'chaplin'

  # Base class for all collections.
  class Collection extends Chaplin.Collection
    parse: (resp) ->
      resp.QueryResult.Results
