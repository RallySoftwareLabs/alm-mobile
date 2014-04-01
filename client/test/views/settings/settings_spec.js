var React = require('react');
var ReactTestUtils = React.addons.TestUtils;
var app = require('application');
var Iteration = require('models/iteration');
var Project = require('models/project');
var Session = require('models/session');
var SettingsView = require('views/settings/settings');
var Iterations = require('collections/iterations');
var Projects = require('collections/projects');

describe('views/settings/settings', function() {
    beforeEach(function() {
        this.project = new Project({ _ref: '/project/1' });
        this.iteration = new Iteration({ _ref: '/iteration/10' });
        this.iterations = new Iterations([
            this.iteration,
            new Iteration({ _ref: '/iteration/11' })
        ]);
        this.session = new Session({
            iteration: this.iteration,
            iterations: this.iterations,
            project: this.project,
            mode: 'board',
            boardField: 'ScheduleState'
        });
    });

    describe('changing project', function() {
        beforeEach(function() {
            this.projects = new Projects([
                this.project,
                new Project({ _ref: '/project/2' })
            ]);
            this.view = ReactTestUtils.renderIntoDocument(SettingsView({
                model: this.session,
                projects: this.projects
            }));
        });

        it('should publish event on project change', function() {
            var eventSpy = this.spy();
            this.subscribeEvent('changeProject', eventSpy);

            var projectField = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'project-select').getDOMNode();
            projectField.options[0].selected = false;
            projectField.options[1].selected = true;
            ReactTestUtils.Simulate.change(projectField);
            
            expect(eventSpy).to.have.been.calledOnce;
            expect(eventSpy).to.have.been.calledWith(this.projects.at(1).get('_ref'));
        });

        it('should record action on project change', function() {
            var projectField = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'project-select').getDOMNode();
            projectField.options[0].selected = false;
            projectField.options[1].selected = true;
            ReactTestUtils.Simulate.change(projectField);
            expect(app.aggregator.recordAction).to.have.been.calledOnce;
            expect(app.aggregator.recordAction).to.have.been.calledWith({
                component: this.view,
                description: "changed project"
            });
        });
    });
});