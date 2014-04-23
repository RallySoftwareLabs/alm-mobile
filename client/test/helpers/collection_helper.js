var $ = require('jquery');

beforeEach(function() {
    this.stubCollectionFetch = function(collection, property, items, fn) {
        return this.stub(collection.prototype, property, function(opts) {
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