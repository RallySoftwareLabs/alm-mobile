var _ = require('underscore');
var Backbone = require('backbone');
var Promise = require('es6-promise').Promise;
var FetchAllPagesMixin = require('lib/fetch_all_pages_mixin');
var Messageable = require('lib/messageable');

// Base class for all collections.
var Collection = Backbone.Collection.extend({
    initialize: function() {
        Backbone.Model.prototype.initialize.apply(this, arguments);
        this.synced = false;
        this.once('sync', function() { this.synced = true; }, this);
    },

    /**
     * Convert jQuery Deferred to ES6-compliant promises
     */
    fetch: function() {
        return Promise.resolve(Backbone.Model.prototype.fetch.apply(this, arguments));
    },

    parse: function(resp) {
        if (resp.QueryResult) {
            return resp.QueryResult.Results;
        }
        return resp;
    },

    isSynced: function() {
        return this.synced;
    },

    setSynced: function(synced) {
        this.synced = synced;
    }
});

_.extend(Collection.prototype, Messageable);
_.extend(Collection.prototype, FetchAllPagesMixin);

module.exports = Collection;