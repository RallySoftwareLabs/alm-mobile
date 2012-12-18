# Base class for all collections.
module.exports = Backbone.Collection.extend
  parse: (resp) ->
    resp.QueryResult.Results

