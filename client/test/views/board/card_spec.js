var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var CardView = require('views/board/card');
var UserStory = require('models/user_story');

describe('views/board/card', function() {
    it('should call callback on card click', function() {
        var userstory = new UserStory({
            FormattedID: 'S12345'
        });
        var eventSpy = this.spy();
        var view = ReactTestUtils.renderIntoDocument(CardView({
            model: userstory,
            onCardClick: eventSpy
        }));
        
        ReactTestUtils.Simulate.click(view.getDOMNode());

        expect(eventSpy).to.have.been.calledOnce;
        expect(eventSpy).to.have.been.calledWith(view, userstory);
    });

    it('should record action on card click', function() {
        var userstory = new UserStory({
            FormattedID: 'S12345'
        });
        var view = ReactTestUtils.renderIntoDocument(CardView({
            model: userstory,
            onCardClick: function() {}
        }));
        
        ReactTestUtils.Simulate.click(view.getDOMNode());

        expect(app.aggregator.recordAction).to.have.been.calledOnce;
        expect(app.aggregator.recordAction).to.have.been.calledWith({
            component: view,
            description: "clicked card"
        });
    });
});