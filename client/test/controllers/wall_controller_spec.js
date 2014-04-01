var $ = require('jquery');
var app = require('application');
var appConfig = require('app_config');
var Messageable = require('lib/messageable');
var utils = require('lib/utils');
var WallController = require('controllers/wall_controller');
var Projects = require('collections/projects');
var Preferences = require('collections/preferences');
var UserStories = require('collections/user_stories');
var Preference = require('models/preference');
var Project = require('models/project');
var Session = require('models/session');
var User = require('models/user');
var UserStory = require('models/user_story');
var CreateView = require('views/wall/create');

describe('controllers/wall_controller', function() {
    beforeEach(function() {
        var View = function() {};
        _.extend(View.prototype, Messageable);
        this.renderReactComponentStub = this.stub(WallController.prototype, 'renderReactComponent', function() {
            return new View();
        });
        this.markFinishedStub = this.stub(WallController.prototype, 'markFinished');

        this.wallController = new WallController();
    });

    afterEach(function() {
        this.wallController.dispose();
    });

    describe('#create', function() {
        beforeEach(function() {
            var me = this;
            this.stub(Projects.prototype, 'fetchAllPages', function() {
                d = $.Deferred();
                me.project = this.add({Name: 'Project 1'});
                d.resolve(this);
                return d.promise();
            });
            this.fetchProjectsSpy = this.spy(Projects, 'fetchAll');
        });

        it('should fetch all projects', function() {
            this.wallController.create();
            expect(this.fetchProjectsSpy).to.have.been.calledOnce;
        });

        it('should render the view', function() {
            this.wallController.create();
            expect(this.renderReactComponentStub).to.have.been.calledOnce;
            expect(this.renderReactComponentStub).to.have.been.calledWith(CreateView);
            expect(this.renderReactComponentStub.args[0][1].model.first()).to.equal(this.project);
        });

        it('should mark finished on fetch complete', function(done) {
            var me = this;
            this.wallController.create();
            this.fetchProjectsSpy.returnValues[0].then(function() {
                expect(me.markFinishedStub).to.have.been.calledOnce;
                done();
            });
        });

        it('should save preference on wallcreate', function(done) {
            var updateWallPreferenceStub = this.stub(Preferences.prototype, 'updateWallPreference').returns(
                this.promiseResolvingTo()
            );
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

            this.fetchAllPagesStub = this.stub(Projects.prototype, 'fetchAllPages').returns(
                this.promiseResolvingTo(me.projects)
            );
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

    describe('#show', function() {
        beforeEach(function() {
            var me = this;
            this.stubPIFactory();
            this.wallPref = new Preference({
                Value: JSON.stringify({
                    chosenStates: ["abc", "def"]
                })
            });

            this.stub(Preferences.prototype, 'fetchWallPref', function() {
                d = $.Deferred();
                this.add(me.wallPref);
                d.resolve(this);
                return d.promise();
            });

            this.stub(WallController.prototype, 'whenProjectIsLoaded', function(options) {
                options.fn.call(this);
            });

            var project = new Project({Name: 'Project 1'});
            this.stubCollectionFetch(Projects, 'fetchAllPages', project);
            Projects.fetchAll();

            this.stubCollectionFetch(this.initiativesCollection, 'fetchAllPages', new this.initiativeModel({
                _refObjectUUID: 'initiative-1234'
            }));

            this.stubCollectionFetch(this.featuresCollection, 'fetchAllPages', new this.featureModel({
                _refObjectUUID: 'feature-1234',
                Parent: {
                    _refObjectUUID: 'initiative-1234'
                }
            }));

            this.stubCollectionFetch(UserStories, 'fetchAllPages', new UserStory({
                _refObjectUUID: 'story-1234',
                PortfolioItem: {
                    _refObjectUUID: 'feature-1234'
                }
            }));

            app.session = new Session({ project: project });

        });
        it('should parent artifacts properly', function(done) {
            var me = this;

            this.stub(appConfig, 'isProd').returns(false);
            this.wallController.show('12345').then(function() {
                expect(me.wallController.initiatives.length).to.equal(1);

                var initiative = me.wallController.initiatives.first();
                expect(initiative.get('_refObjectUUID')).to.equal('initiative-1234');
                expect(initiative.features.length).to.equal(1);

                var feature = initiative.features.first();
                expect(feature.get('_refObjectUUID')).to.equal('feature-1234');
                expect(feature.userStories.length).to.equal(1);

                var userStory = feature.userStories.first();
                expect(userStory.get('_refObjectUUID')).to.equal('story-1234');
                done();
            });
        });
        it('should listen for realtime messages in production', function(done) {
            this.stub(appConfig, 'isProd').returns(true);
            var realtimeStub = this.stub(this.wallController, 'listenForRealtimeUpdates');

            this.wallController.show('12345').then(function() {
                expect(realtimeStub).to.have.been.calledOnce;
                done();
            });
        });
        it('should not listen for realtime messages when not in production', function(done) {
            this.stub(appConfig, 'isProd').returns(false);
            var realtimeStub = this.stub(this.wallController, 'listenForRealtimeUpdates');

            this.wallController.show('12345').then(function() {
                expect(realtimeStub).not.to.have.been.called;
                done();
            });
        });
    });
});
