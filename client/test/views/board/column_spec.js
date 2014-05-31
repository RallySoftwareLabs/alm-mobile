var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var CardView = require('views/board/card');
var ColumnView = require('views/board/column');
var Artifacts = require('collections/artifacts');
var Artifact = require('models/artifact');

describe('views/board/column', function() {
  it('should call callback on header click', function() {
    var artifacts = new Artifacts([
      new Artifact({
        FormattedID: 'S12345'
      })
    ]);
    var eventSpy = this.spy();
    var view = ReactTestUtils.renderIntoDocument(ColumnView({
      artifacts: artifacts,
      columns: ['columnValue', 'otherColumn'],
      boardField: 'ScheduleState',
      value: 'columnValue',
      singleColumn: true,
      abbreviateHeader: false,
      showIteration: false,
      onCardClick: function() {},
      onHeaderClick: eventSpy
    }));
    
    ReactTestUtils.Simulate.click(view.refs.header.getDOMNode());

    expect(eventSpy).to.have.been.calledOnce;
    expect(eventSpy).to.have.been.calledWith(view, 'columnValue');
  });

  it('should record action on header click', function() {
    var artifacts = new Artifacts([
      new Artifact({
        FormattedID: 'S12345'
      })
    ]);
    var eventSpy = this.spy();
    var view = ReactTestUtils.renderIntoDocument(ColumnView({
      artifacts: artifacts,
      columns: ['columnValue', 'otherColumn'],
      boardField: 'ScheduleState',
      value: 'columnValue',
      singleColumn: true,
      abbreviateHeader: false,
      showIteration: false,
      onCardClick: function() {},
      onHeaderClick: eventSpy
    }));
    
    ReactTestUtils.Simulate.click(view.refs.header.getDOMNode());

    expect(app.aggregator.recordAction).to.have.been.calledOnce;
    expect(app.aggregator.recordAction).to.have.been.calledWith({
      component: view,
      description: "clicked column"
    });
  });
  it('should only render cards for matching artifacts', function() {
    var artifacts = new Artifacts([
      new Artifact({ _ref: '/hierarchicalrequirement/1', FormattedID: 'S1', Name: 'a1', ScheduleState: 'Defined' }),
      new Artifact({ _ref: '/hierarchicalrequirement/2', FormattedID: 'S2', Name: 'a2', ScheduleState: 'In-Progress' }),
      new Artifact({ _ref: '/hierarchicalrequirement/3', FormattedID: 'S3', Name: 'a3', ScheduleState: 'Defined' })
    ]);
    var view = ReactTestUtils.renderIntoDocument(ColumnView({
      artifacts: artifacts,
      columns: ['Defined', 'In-Progress'],
      boardField: 'ScheduleState',
      value: 'Defined',
      singleColumn: true,
      abbreviateHeader: false,
      showIteration: false,
      onCardClick: function() {},
      onHeaderClick: function() {}
    }));
    var cards = ReactTestUtils.scryRenderedComponentsWithType(view, CardView);
    expect(cards.length).to.equal(2);
    expect(_.map(cards, function(card) { return card.props.model.get('Name'); })).to.eql(['a1', 'a3']);
  });
});