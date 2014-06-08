var React = require('react');
var ReactTestUtils = React.addons.TestUtils;
var Fluxxor = require('fluxxor');
var app = require('application');
var SettingsActions = require('actions/settings_actions');
var Iteration = require('models/iteration');
var Project = require('models/project');
var Session = require('models/session');
var SettingsView = require('views/settings/settings');
var Iterations = require('collections/iterations');
var Projects = require('collections/projects');

describe('views/settings/settings', function() {
  beforeEach(function() {
    var me = this;
    me.project = new Project({ _ref: '/project/1' });
    me.iteration = new Iteration({ _ref: '/iteration/10' });
    me.iterations = new Iterations([
      me.iteration,
      new Iteration({ _ref: '/iteration/11' })
    ]);
    me.storeState = {
      iteration: me.iteration,
      iterations: me.iterations,
      project: me.project,
      projects: new Projects([
        this.project,
        new Project({ _ref: '/project/2' })
      ]),
      mode: 'board',
      boardField: 'ScheduleState'
    };
    me.store = Object.create({
      getState: function() {
        return me.storeState;
      }
    });
    _.extend(me.store, Backbone.Events);
  });

  describe('changing project', function() {
    beforeEach(function() {
      this.view = ReactTestUtils.renderIntoDocument(SettingsView({
        flux: new Fluxxor.Flux({SettingsStore: this.store}, SettingsActions)
      }));
    });

    it('should call action on project change', function() {
      var eventSpy = this.stub(this.view.getFlux().actions, 'setProject');

      var projectField = ReactTestUtils.findRenderedDOMComponentWithClass(this.view, 'project-select').getDOMNode();
      projectField.options[0].selected = false;
      projectField.options[1].selected = true;
      ReactTestUtils.Simulate.change(projectField);
      
      expect(eventSpy).to.have.been.calledOnce;
      expect(eventSpy).to.have.been.calledWith(this.storeState.projects.at(1).get('_ref'));
    });

    it('should record action on project change', function() {
      var eventSpy = this.stub(this.view.getFlux().actions, 'setProject');

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