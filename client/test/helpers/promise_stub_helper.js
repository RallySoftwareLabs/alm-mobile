var $ = require('jquery');

beforeEach(function() {
    this.promiseResolvingTo = function(value) {
        var d = $.Deferred();
        d.resolve(value);
        return d.promise();
    }
});