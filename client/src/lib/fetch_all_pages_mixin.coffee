Promise = require('es6-promise').Promise
pagesize = 200

module.exports = {
  fetchAllPages: (options = {}) ->
    options.data ?= {}
    options.data.pagesize ?= pagesize
    @fetch(options).then (firstFetch) =>
      totalResults = firstFetch.QueryResult.TotalResultCount
      @_fetchRemaining(totalResults, options)

  _fetchRemaining: (totalCount, options) ->
    pagesize = options.data.pagesize
    start = pagesize + 1
    opts = _.assign(options, remove: false)
    remainingFetches = while totalCount >= start
      opts.data.start = start
      fetch = @fetch(opts)
      start += pagesize
      fetch

    Promise.all(remainingFetches).then =>
      @trigger('complete')
}