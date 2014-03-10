define([
    'chai',
    'sinon',
    'sinon-chai'
], function(
    chai,
    sinon,
    sinonChai
) {
    chai.use(sinonChai);
    window.expect = chai.expect;

    var sinonSandboxSetUp = function(spec) {
        if (spec.__sandbox__) {
            return;
        }
        var config = sinon.getConfig(sinon.config);
        config.injectInto = config.injectIntoThis && spec || config.injectInto;
        spec.__sandbox__ = sinon.sandbox.create(config);
      };

    var sinonSandboxTearDown = function(spec) {
        spec.__sandbox__.verifyAndRestore()
    };

    beforeEach(function() {
        sinonSandboxSetUp(this);
    });

    afterEach(function() {
        sinonSandboxTearDown(this);
    });
});