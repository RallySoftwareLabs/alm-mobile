var moment = require('moment');
var Iterations = require('collections/iterations');
var Iteration = require('models/iteration');

describe('collections/iterations', function() {
    describe('#findClosestAsCurrent', function() {
        it('should return null if the collection has no iterations', function() {
            expect(new Iterations().findClosestAsCurrent()).to.be.null;
        });
        it('should return current iteration if the collection has one', function() {
            var current = new Iteration({ StartDate: moment().subtract(1, 'days').format(), EndDate: moment().add(1, 'days').format()});
            var future = new Iteration({ StartDate: moment().add(2, 'days').format(), EndDate: moment().add(3, 'days').format()});
            var iterations = new Iterations([current, future]);
            expect(iterations.findClosestAsCurrent()).to.equal(current);
        });
        it('should return closest iteration, based on start date, if the collection has no current iteration', function() {
            var closest = new Iteration({ StartDate: moment().add(1, 'days').format(), EndDate: moment().add(2, 'days').format()});
            var further = new Iteration({ StartDate: moment().add(3, 'days').format(), EndDate: moment().add(4, 'days').format()});
            var furthest = new Iteration({ StartDate: moment().subtract(2, 'days').format(), EndDate: moment().format()});
            var iterations = new Iterations([closest, further, furthest]);
            expect(iterations.findClosestAsCurrent()).to.equal(closest);
        });
    });
});
