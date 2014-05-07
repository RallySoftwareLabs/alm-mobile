/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var DetailMixin = require('views/detail/detail_mixin');
var Children = require('views/field/children');
var Defects = require('views/field/defects');
var Description = require('views/field/description');
var Discussion = require('views/field/discussion');
var Iteration = require('views/field/iteration');
var Name = require('views/field/name');
var Owner = require('views/field/owner');
var StringWithArrows = require('views/field/string_with_arrows');
var Tasks = require('views/field/tasks');
var TitledWell = require('views/field/titled_well');
var WorkProduct = require('views/field/work_product');

module.exports = ReactView.createBackboneClass({
  mixins: [DetailMixin],
  render: function() {
    var model = this.props.model,
        newArtifact = !model.get('_ref'),
        childrenAndOrTasks = model.get('Children') && model.get('Children').Count ?
          (
            <div className="col-xs-3 ChildrenView">
              <Children item={ model } editMode={ newArtifact }/>
            </div>
          )
          :
          model.get('Tasks') && model.get('Tasks').Count ?
            (
              <div className="col-xs-3 TasksView">
                <Tasks item={ model } editMode={ newArtifact }/>
              </div>
            )
            :
            [
            <div className="col-xs-2 ChildrenView">
              <Children item={ model } editMode={ newArtifact }/>
            </div>,
            <div className="col-xs-2 TasksView">
              <Tasks item={ model } editMode={ newArtifact }/>
            </div>
            ];
    return (
      <div className="detail-view" autoFocus="autofocus">
        <div className="row">
          <div className="col-xs-12 NameView">
            <Name item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 ParentView">
            <WorkProduct item={ model }
                         editMode={ newArtifact }
                         field={ model.get('PortfolioItem') ? "PortfolioItem" : "Parent" }
                         label="Parent"/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8">
            <div className="row">
              <div className="col-xs-12 ScheduleStateView">
                <StringWithArrows item={ model } allowedValues={ this.props.allowedValues[this.getBoardField()] } editMode={ newArtifact } field={ this.getBoardField() } label={ this.getScheduleStateLabel() }/>
              </div>
            </div>
            <div className="row">
              <div className="col-xs-12 IterationView">
                <Iteration item={ model } allowedValues={ this.props.allowedValues.Iteration } editMode={ newArtifact } field="Iteration" label="Iteration"/>
              </div>
            </div>
          </div>
          <div className="col-xs-4 OwnerView">
            <Owner item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8 ReleaseView">
            <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.Release } editMode={ newArtifact } field="Release" label="Release"/>
          </div>
          <div className="col-xs-4 ProjectView">
            <TitledWell item={ model } allowedValues={ this.props.allowedValues.Project } editMode={ newArtifact } field='Project' label='Project'/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-3 PlanEstimateView">
            <TitledWell item={ model } editMode={ newArtifact } field='PlanEstimate' label='Plan Est' inputType='number'/>
          </div>
          { childrenAndOrTasks }
          <div className="col-xs-3 DefectsView">
            <Defects item={ model } editMode={ newArtifact }/>
          </div>
          <div className="col-xs-2 DiscussionView">
            <Discussion item={ model } editMode={ newArtifact }/>
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
