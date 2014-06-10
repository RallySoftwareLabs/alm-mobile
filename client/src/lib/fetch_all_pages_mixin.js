var Promise = require('es6-promise').Promise;
var pagesize = 200;

module.exports = {
  fetchAllPages: function(options) {
    var me = this;
    var opts = options || {};
    opts.data = opts.data || {};
    opts.data.pagesize = opts.data.pagesize || pagesize;
    return me.fetch(opts).then(function(firstFetch) {
      var totalResults = firstFetch.QueryResult.TotalResultCount;
      return me._fetchRemaining(totalResults, opts);
    });
  },

  _fetchRemaining: function(totalCount, options) {
    var fetch;
    var me = this;
    var pagesize = options.data.pagesize;
    var start = pagesize + 1;
    var opts = _.assign(options, { remove: false });
    var remainingFetches = [];
    while (totalCount >= start) {
      opts.data.start = start;
      fetch = this.fetch(opts);
      start += pagesize;
      remainingFetches.push(fetch);
    }

    return Promise.all(remainingFetches).then(function() {
      me.trigger('complete');
      return me;
    });
  }
};