var $ = require('jquery');

beforeEach(function() {
    this.stubCollectionFetch = function(collection, property, items) {
        return this.stub(collection.prototype, property, function() {
            var d = $.Deferred();
            this.add(items);
            d.resolve(this);
            return d.promise();
        });
    };
});