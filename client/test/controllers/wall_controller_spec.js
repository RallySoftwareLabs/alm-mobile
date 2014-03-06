define([
    'jquery',
    'application',
    'lib/messageable',
    'lib/utils',
    'controllers/wall_controller',
    'collections/projects',
    'collections/preferences',
    'models/project',
    'models/session',
    'models/user'
], function(
    $,
    app,
    Messageable,
    utils,
    WallController,
    Projects,
    Preferences,
    Project,
    Session,
    User
) {
    describe('controllers/wall_controller', function() {
        beforeEach(function() {
            var View = function() {};
            _.extend(View.prototype, Messageable);
            this.renderReactComponentStub = this.stub(WallController.prototype, 'renderReactComponent', function() {
                return new View();
            });
            this.projects = Projects.projects = new Projects();
            this.markFinishedStub = this.stub(WallController.prototype, 'markFinished');

            this.wallController = new WallController();
        });

        afterEach(function() {
            this.wallController.dispose();
        });

        describe('#create', function() {
            beforeEach(function() {
                var me = this;
                this.fetchProjectsStub = this.stub(Projects, 'fetchAll', function() {
                    var d = $.Deferred();
                    d.resolve(me.projects);
                    return d.promise();
                });
            });

            it('should fetch all projects', function() {
                this.wallController.create();
                expect(this.fetchProjectsStub).to.have.been.calledOnce;
            });

            it('should render the view', function() {
                this.wallController.create();
                expect(this.renderReactComponentStub).to.have.been.calledOnce;
            });

            it('should mark finished on fetch complete', function(done) {
                var me = this;
                this.wallController.create();
                this.fetchProjectsStub.returnValues[0].then(function() {
                    expect(me.markFinishedStub).to.have.been.calledOnce;
                    done();                    
                });
            });

            it('should save preference on wallcreate', function(done) {
                var updateWallPreferenceStub = this.stub(Preferences.prototype, 'updateWallPreference', function() {
                    var d = $.Deferred();
                    d.resolve();
                    return d.promise();
                });
                var redirectToStub = this.stub(WallController.prototype, 'redirectTo');
                var user = new User();
                var wallInfo = {
                    project: new Project({
                        _ref: '/project/1234'
                    })
                };

                app.session = new Session({ user: user });

                this.wallController.create();
                this.wallController.view.publishEvent('createwall', wallInfo);

                expect(updateWallPreferenceStub).to.have.been.calledOnce;
                updateWallPreferenceStub.returnValues[0].then(function() {
                    expect(updateWallPreferenceStub.firstCall.args[0]).to.equal(user);
                    expect(updateWallPreferenceStub.firstCall.args[1]).to.equal(wallInfo);
                    expect(redirectToStub).to.have.been.calledOnce;
                    expect(redirectToStub).to.have.been.calledWith('/wall/1234');
                    done();
                });
            });

        });

        describe('#splash', function() {
            beforeEach(function() {
                var me = this;
                this.prefs = new Preferences();
                this.fetchWallPrefsStub = this.stub(Preferences.prototype, 'fetchWallPrefs', function() {
                    var d = $.Deferred();
                    d.resolve(me.prefs);
                    return d.promise();
                });

                this.createQueryFromCollectionStub = this.stub(utils, 'createQueryFromCollection');

                this.fetchAllPagesStub = this.stub(Projects.prototype, 'fetchAllPages', function() {
                    var d = $.Deferred();
                    d.resolve(me.projects);
                    return d.promise();
                });
            });

            it('should fetch all the wall preferences and projects', function() {
                this.wallController.splash();
                expect(this.fetchWallPrefsStub).to.have.been.calledOnce;
                expect(this.fetchAllPagesStub).to.have.been.calledOnce;
            });

            it('should render the view', function() {
                this.wallController.splash();
                expect(this.renderReactComponentStub).to.have.been.calledOnce;
            });
        });
    });
});
