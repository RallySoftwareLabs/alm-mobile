var $ = require('jquery');
var _ = require('underscore');

beforeEach(function() {
    this.stubCollectionFetch = function(collection, property, items, fn) {
        var obj = _.has(collection, property) ? collection : collection.prototype;
        return this.stub(obj, property, function(opts) {
            var d = $.Deferred();
            this.add(items);
            if (_.isFunction(fn)) {
                fn.call(this, opts);
            }
            d.resolve(this);
            return d.promise();
        });
    };
});