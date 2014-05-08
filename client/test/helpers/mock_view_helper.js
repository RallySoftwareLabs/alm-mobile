var Messageable = require('lib/messageable');

beforeEach(function() {
    this.stubViewRender = function(Controller, config) {
        var View = function() {};
        _.extend(View.prototype, Messageable);
        _.extend(View.prototype, {
            setState: this.stub()
        });
        _.extend(View.prototype, config);
        return this.stub(Controller.prototype, 'renderReactComponent').returns(new View());
    };
});