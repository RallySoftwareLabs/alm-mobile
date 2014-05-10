var Promise = require('es6-promise').Promise;
var _ = require('underscore');

beforeEach(function() {
    this.stubCollectionFetch = function(collection, property, items, fn) {
        var obj = _.has(collection, property) ? collection : collection.prototype;
        return this.stub(obj, property, function(opts) {
            this.add(items);
            if (_.isFunction(fn)) {
                fn.call(this, opts);
            }
            return Promise.resolve(this);
        });
    };
});