var ReactTestUtils = React.addons.TestUtils;
var Backbone = require('backbone');
var app = require('application');
var Artifacts = require('collections/artifacts');
var BoardStore = require('stores/board_store');

describe('stores/board', function() {
    beforeEach(function() {
        this.boardField = 'ScheduleState';
        this.project =new Backbone.Model({
            _ref: '/project/12345'
        });
        this.user = new Backbone.Model({
            _ref: '/user/23456'
        });
        this.boardColumns = ['abc', 'def'];
        this.fetchStub = this.stubCollectionFetch(Artifacts, 'fetch', [
            new Backbone.Model({ ScheduleState: 'abc', Name: '1' }),
            new Backbone.Model({ ScheduleState: 'abc', Name: '2' }),
            new Backbone.Model({ ScheduleState: 'def', Name: '3' })
        ]);
    });
    describe('initial fetch', function() {
        it('should scope query to project when passed in', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            expect(this.fetchStub).to.have.been.calledOnce;
            expect(this.fetchStub.firstCall.args[0].data.project).to.equal('/project/12345');
            expect(this.fetchStub.firstCall.args[0].data.projectScopeUp).to.be.false;
            expect(this.fetchStub.firstCall.args[0].data.projectScopeDown).to.be.true;
        });
        it('should query for all columns if none specified', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "abc")');
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "def")');
        });
        it('should query for all columns even if visibleColumn passed in', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                visibleColumn: 'abc'
            });
            this.boardStore.load();
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "abc")');
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(ScheduleState = "def")');
        });
        it('should query by user when passed in', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                user: this.user
            });
            this.boardStore.load();
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(Owner = "/user/23456")');
        });
        it('should query by iteration when passed in', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                iteration: new Backbone.Model({ _ref: '/iteration/987'})
            });
            this.boardStore.load();
            expect(this.fetchStub.firstCall.args[0].data.query).to.contain('(Iteration = "/iteration/987")');
        });
        it('should populate columns with results', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            var columns = this.boardStore.getColumns();
            var abcColumn = _.find(columns, _.isAttributeEqual('value', 'abc'));
            expect(abcColumn.artifacts).to.have.length(2);
            expect(
                abcColumn.artifacts.map(_.getAttribute('Name'))
            ).to.eql(['1', '2']);
            
            var defColumn = _.find(columns, _.isAttributeEqual('value', 'def'));
            expect(defColumn.artifacts).to.have.length(1);
            expect(
                defColumn.artifacts.map(_.getAttribute('Name'))
            ).to.eql(['3']);
        });
    });

    describe('#isZoomedIn', function() {
        it('should return false if constructed without a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            expect(this.boardStore.isZoomedIn()).to.be.false;
        });
        it('should return true if constructed with a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                visibleColumn: 'abc'
            });
            expect(this.boardStore.isZoomedIn()).to.be.true;
        });
        it('should return true if showOnlyColumn is called', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            this.boardStore.showOnlyColumn('abc');
            expect(this.boardStore.isZoomedIn()).to.be.true;
        });
    });

    describe('#getVisibleColumns', function() {
        it('should return all columns if constructed without a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            expect(this.boardStore.getVisibleColumns()).to.have.length(2);
            expect(
                _.map(this.boardStore.getVisibleColumns(), _.getAttribute('value'))
            ).to.eql(['abc', 'def']);
        });
        it('should return one column if constructed with a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                visibleColumn: 'abc'
            });
            expect(this.boardStore.getVisibleColumns()).to.have.length(1);
            expect(
                _.map(this.boardStore.getVisibleColumns(), _.getAttribute('value'))
            ).to.be.eql(['abc']);
        });
        it('should return one column if showOnlyColumn is called', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            this.boardStore.showOnlyColumn('abc');
            expect(this.boardStore.getVisibleColumns()).to.have.length(1);
            expect(
                _.map(this.boardStore.getVisibleColumns(), _.getAttribute('value'))
            ).to.be.eql(['abc']);
        });
    });

    describe('#getColumns', function() {
        it('should return all columns if constructed without a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            expect(this.boardStore.getColumns()).to.have.length(2);
            expect(
                _.map(this.boardStore.getColumns(), _.getAttribute('value'))
            ).to.eql(['abc', 'def']);
        });
        it('should return all columns if constructed with a column', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project,
                visibleColumn: 'abc'
            });
            expect(this.boardStore.getColumns()).to.have.length(2);
            expect(
                _.map(this.boardStore.getColumns(), _.getAttribute('value'))
            ).to.be.eql(['abc', 'def']);
        });
        it('should return all columns if showOnlyColumn is called', function() {
            this.boardStore = new BoardStore({
                boardField: this.boardField,
                boardColumns: this.boardColumns,
                project: this.project
            });
            this.boardStore.load();
            this.boardStore.showOnlyColumn('abc');
            expect(this.boardStore.getColumns()).to.have.length(2);
            expect(
                _.map(this.boardStore.getColumns(), _.getAttribute('value'))
            ).to.be.eql(['abc', 'def']);
        });
    });


});