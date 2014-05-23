var Backbone = require('backbone');
var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var Column = require('models/column');
var BoardView = require('views/board/board');
var ColumnView = require('views/board/column');

describe('views/board/board', function() {

  describe('zoomed in', function() {
    beforeEach(function() {
      var me = this;
      this.columns = [
        new Column({ boardField: 'ScheduleState', value: 'Defined' }),
        new Column({ boardField: 'ScheduleState', value: 'In-Progress' })
      ];
      this.store = Object.create({
        getColumns: function() {
          return me.columns;
        },
        getScheduleStates: function() {
          return ['Defined', 'In-Progress'];
        },
        getIteration: function() {
          return null;
        },
        getIterations: function() {
          return [];
        }
      });
      _.extend(this.store, Backbone.Events);
    });
    it('should not be when constructed without a column', function() {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        store: this.store
      }));
      var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
      expect(columns.length).to.equal(2);
    });
    it('should be when constructed with a column', function() {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        store: this.store,
        visibleColumn: 'Defined'
      }));
      var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
      expect(columns.length).to.equal(1);
    });
    it('should be when column is clicked', function(done) {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        store: this.store
      }));
      view.on('columnzoom', function() {
        var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
        expect(columns.length).to.equal(1);
        done();
      });
      var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
      columns[0].props.onHeaderClick(columns[0], this.columns[0]);
    });
  });
});