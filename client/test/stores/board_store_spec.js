var Promise = require('es6-promise').Promise;
var ReactTestUtils = React.addons.TestUtils;
var Backbone = require('backbone');
var app = require('application');
var Artifacts = require('collections/artifacts');
var Iteration = require('models/iteration');
var UserStory = require('models/user_story');
var BoardStore = require('stores/board_store');

describe('stores/board', function() {
  beforeEach(function() {
    var artifacts = [
      new Backbone.Model({ ScheduleState: 'abc', Name: '1' }),
      new Backbone.Model({ ScheduleState: 'abc', Name: '2' }),
      new Backbone.Model({ ScheduleState: 'def', Name: '3' })
    ];
    this.boardField = 'ScheduleState';
    this.project = new Backbone.Model({
      _ref: '/project/12345'
    });
    this.user = new Backbone.Model({
      _ref: '/user/23456'
    });
    this.boardColumns = ['abc', 'def'];
    this.stub(UserStory, 'getAllowedValues').returns(Promise.resolve([
      { StringValue: 'abc' },
      { StringValue: 'def' },
      { StringValue: 'ghi' }
    ]));
    this.iteration = new Iteration({
      _ref: '/iteration/1',
      Project: {
        _ref: '/project/12345'
      }
    });
    this.iterationFetchStub = this.stub(this.iteration, 'fetchScheduledItems', function() {
      this.artifacts = new Artifacts(artifacts);
      return Promise.resolve(this.artifacts);
    });
    this.artifactsFetchStub = this.stubCollectionFetch(Artifacts, 'fetchAllPages', artifacts);
  });
  describe('initial fetch', function() {
    it('should scope query to project when passed in', function() {
      var me = this;
      this.boardStore = new BoardStore({
        iteration: this.iteration,
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project
      });
      return this.boardStore.load().then(function() {
        expect(me.iterationFetchStub).to.have.been.calledOnce;
        expect(me.iterationFetchStub.firstCall.args[0].project).to.equal('/project/12345');
        expect(me.iterationFetchStub.firstCall.args[0].projectScopeUp).to.be.false;
        expect(me.iterationFetchStub.firstCall.args[0].projectScopeDown).to.be.true;
      });
    });
    it('should query for all columns if none specified', function() {
      var me = this;
      this.boardStore = new BoardStore({
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project
      });
      return this.boardStore.load().then(function() {
        expect(me.artifactsFetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "abc")');
        expect(me.artifactsFetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "def")');
      });
    });
    it('should query for all columns even if visibleColumn passed in', function() {
      var me = this;
      this.boardStore = new BoardStore({
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project,
        visibleColumn: 'abc'
      });
      return this.boardStore.load().then(function() {
        expect(me.artifactsFetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "abc")');
        expect(me.artifactsFetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "def")');
      });
    });
    it('should query by user when passed in', function() {
      var me = this;
      this.boardStore = new BoardStore({
        iteration: this.iteration,
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project,
        user: this.user
      });
      return this.boardStore.load().then(function() {
        expect(me.iterationFetchStub.firstCall.args[0].query).to.contain('(Owner = "/user/23456")');
      });
    });
    it('should query only by iteration when passed in', function() {
      var me = this;
      this.boardStore = new BoardStore({
        iteration: this.iteration,
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project,
      });
      return this.boardStore.load().then(function() {
        expect(me.iterationFetchStub.firstCall.args[0].query).to.contain('(Iteration = "' + me.iteration.get('_ref') + '")');
        expect(me.iterationFetchStub.firstCall.args[0].query).not.to.contain('(ScheduleState =');
      });
    });
  });

  describe('#getState', function() {
    it('should return all columns if constructed without a column', function() {
      this.boardStore = new BoardStore({
        iteration: this.iteration,
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project
      });
      expect(this.boardStore.getState().columns).to.have.length(2);
      expect(this.boardStore.getState().columns).to.be.eql(['abc', 'def']);
    });
    it('should return all columns if constructed with a column', function() {
      this.boardStore = new BoardStore({
        iteration: this.iteration,
        boardField: this.boardField,
        boardColumns: this.boardColumns,
        project: this.project,
        visibleColumn: 'abc'
      });
      expect(this.boardStore.getState().columns).to.have.length(2);
      expect(this.boardStore.getState().columns).to.be.eql(['abc', 'def']);
    });
  });

});