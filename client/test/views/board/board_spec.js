var Backbone = require('backbone');
var ReactTestUtils = React.addons.TestUtils;
var Fluxxor = require('fluxxor');
var app = require('application');
var BoardActions = require('actions/board_actions');
var Artifacts = require('collections/artifacts');
var Column = require('models/column');
var BoardView = require('views/board/board');
var ColumnView = require('views/board/column');
var _ = require('lodash');

describe('views/board/board', function() {

  describe('zoomed in', function() {
    beforeEach(function() {
      var me = this;
      this.columns = ['Defined', 'In-Progress'];
      this.store = Object.create({
        getState: function() {
          return {
            columns: me.columns,
            scheduleStates: ['Defined', 'In-Progress'],
            iteration: null,
            iterations: [],
            artifacts: new Artifacts()
          };
        }
      });
      _.extend(this.store, Backbone.Events);
    });
    it('should not be when constructed without a column', function() {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        flux: new Fluxxor.Flux({BoardStore: this.store}, BoardActions)
      }));
      var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
      expect(columns.length).to.equal(2);
    });
    it('should be when constructed with a column', function() {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        flux: new Fluxxor.Flux({BoardStore: this.store}, BoardActions),
        visibleColumn: 'Defined'
      }));
      var columns = ReactTestUtils.scryRenderedComponentsWithType(view, ColumnView);
      expect(columns.length).to.equal(1);
    });
    it('should be when column is clicked', function(done) {
      var view = ReactTestUtils.renderIntoDocument(BoardView({
        flux: new Fluxxor.Flux({BoardStore: this.store}, BoardActions)
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