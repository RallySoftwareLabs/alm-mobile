var _ = require('underscore');
var Backbone = require('backbone');
var Promise = require('es6-promise').Promise;
var Messageable = require('lib/messageable');
var SchemaMixin = require('models/base/schema_mixin');

/**
 * Base class for all models.
 */
var Model = Backbone.Model.extend({
    idAttribute: '_refObjectUUID',

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
        if (resp._ref) {
            return resp;
        }
        if (resp.OperationResult) {
            return resp.OperationResult.Object;
        }
        if (resp.CreateResult) {
            return resp.CreateResult.Object;
        }
        return _.values(resp)[0]; // Get value for only key
    },

    isSynced: function() {
        return this.synced;
    },

    setSynced: function(synced) {
        this.synced = synced;
    }
});

_.extend(Model, SchemaMixin.static);
_.extend(Model.prototype, Messageable);
_.extend(Model.prototype, SchemaMixin.prototype);

module.exports = Model;