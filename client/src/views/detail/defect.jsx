/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var DetailMixin = require('views/detail/detail_mixin');
var Defects = require('views/field/defects');
var Description = require('views/field/description');
var Discussion = require('views/field/discussion');
var Iteration = require('views/field/iteration');
var Name = require('views/field/name');
var Owner = require('views/field/owner');
var Tasks = require('views/field/tasks');
var WorkProduct = require('views/field/work_product');
var TitledWell = require('views/field/titled_well');
var Toggle = require('views/field/toggle');
var StringWithArrows = require('views/field/string_with_arrows');

module.exports = ReactView.createBackboneClass({
  mixins: [DetailMixin],
  render: function() {
    var model = this.props.model,
        newArtifact = !model.get('_ref');
    return (
      <div className="detail-view" autoFocus="autofocus">
        <div className="row">
          <div className="col-xs-12 NameView">
            <Name item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 RequirementView">
            <WorkProduct item={ model } editMode={ newArtifact } field="Requirement"/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8">
            <div className="row">
              <div className="col-xs-12 ScheduleStateView">
                <StringWithArrows item={ model } allowedValues={ this.props.allowedValues[this.getBoardField()] } editMode={ newArtifact } field={ this.getBoardField() } label={ this.getScheduleStateLabel() } boardColumns={ this.props.boardColumns }/>
              </div>
            </div>
            <div className="row">
              <div className="col-xs-12 StateView">
                <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.State } editMode={ newArtifact } field="State" label="State"/>
              </div>
            </div>
          </div>
          <div className="col-xs-4 OwnerView">
            <Owner item={ model } allowedValues={ this.props.allowedValues.Owner } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8 IterationView">
            <Iteration item={ model } allowedValues={ this.props.allowedValues.Iteration } editMode={ newArtifact } field="Iteration" label="Iteration"/>
          </div>
          <div className="col-xs-4 ProjectView">
            <TitledWell item={ model } allowedValues={ this.props.allowedValues.Project } editMode={ newArtifact } field='Project' label='Project'/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8 ReleaseView">
            <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.Release } editMode={ newArtifact } field="Release" label="Release"/>
          </div>
          <div className="col-xs-4 DiscussionView">
            <Discussion item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-6 PlanEstimateView">
            <TitledWell item={ model } editMode={ newArtifact } field='PlanEstimate' label='Plan Est' inputType='number'/>
          </div>
          <div className="col-xs-6 TasksView">
            <Tasks item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-6 SeverityView">
            <TitledWell item={ model } allowedValues={ this.props.allowedValues.Severity } editMode={ newArtifact } field='Severity' label='Severity'/>
          </div>
          <div className="col-xs-6 PriorityView">
            <TitledWell item={ model } allowedValues={ this.props.allowedValues.Priority } editMode={ newArtifact } field='Priority' label='Priority'/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-6 EnvironmentView">
            <TitledWell item={ model } allowedValues={ this.props.allowedValues.Environment } editMode={ newArtifact } field='Environment' label='Environment'/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 DescriptionView">
            <Description item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        { newArtifact ? this.getButtonsMarkup() : this.getTogglesMarkup() }
      </div>
    );
  }
});
