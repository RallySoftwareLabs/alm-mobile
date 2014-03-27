var React = require('react');
var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var SearchView = require('views/search/search');
var Artifacts = require('collections/artifacts');

describe('views/search/search', function() {
    it('should publish event on form submit', function() {
        var artifacts = new Artifacts();
        var view = ReactTestUtils.renderIntoDocument(SearchView({
            collection: artifacts
        }));
        
        var form = ReactTestUtils.findRenderedDOMComponentWithClass(view, 'search-form');
        var input = view.refs.input.getDOMNode();
        input.value = "search terms";
        ReactTestUtils.Simulate.change(input);
        var searchSpy = this.spy();
        this.subscribeEvent('search', searchSpy);
        ReactTestUtils.Simulate.submit(form);
        expect(searchSpy).to.have.been.calledOnce;
        expect(searchSpy).to.have.been.calledWith("search terms");
    });

    it('should record action when form is submitted', function() {
        var artifacts = new Artifacts();
        var view = ReactTestUtils.renderIntoDocument(SearchView({
            collection: artifacts
        }));
        
        var form = ReactTestUtils.findRenderedDOMComponentWithClass(view, 'search-form');
        var input = view.refs.input.getDOMNode();
        input.value = "search terms";
        ReactTestUtils.Simulate.change(input);
        ReactTestUtils.Simulate.submit(form);
        expect(app.aggregator.recordAction).to.have.been.calledOnce;
        expect(app.aggregator.recordAction).to.have.been.calledWith({
            component: view,
            description: "search submitted"
        });
    });
});