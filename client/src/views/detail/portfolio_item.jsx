/** @jsx React.DOM */
var _ = require('underscore');
var React = require('react');
var app = require('application');
var ReactView = require('views/base/react_view');
var DetailMixin = require('views/detail/detail_mixin');
var Children = require('views/field/children');
var Description = require('views/field/description');
var Discussion = require('views/field/discussion');
var Name = require('views/field/name');
var Owner = require('views/field/owner');
var TitledWell = require('views/field/titled_well');
var Toggle = require('views/field/toggle');
var StringWithArrows = require('views/field/string_with_arrows');
var WorkProduct = require('views/field/work_product');

module.exports = ReactView.createBackboneClass({
  mixins: [DetailMixin],
  render: function() {
    var model = this.props.model,
        newArtifact = !model.get('_ref');
    return (
      <div className="detail-view" autoFocus="autofocus">
        <div className="col-xs-12 NameView">
          <Name item={ model } editMode={ newArtifact }/>
        </div>
        <div className="col-xs-12 ellipsis ParentView">
          <WorkProduct item={ model } editMode={ newArtifact } field="Parent" label="Parent"/>
        </div>
        <div className="col-xs-12 DescriptionView">
          <Description item={ model } editMode={ newArtifact }/>
        </div>

        <div className="col-xs-3 PreliminaryEstimateView">
          <TitledWell item={ model } editMode={ newArtifact } field='PreliminaryEstimate' label='Prelim Est' allowedValues={ this.props.allowedValues.PreliminaryEstimate }/>
        </div>
        <div className="col-xs-3 ChildrenView">
          <Children item={ model } field={ (model.get('Children') && 'Children') || (model.get('UserStories') && 'UserStories') } editMode={ newArtifact }/>
        </div>
        <div className="col-xs-3 DiscussionView">
          <Discussion item={ model } editMode={ newArtifact }/>
        </div>

         <div className="col-xs-3 OwnerView">
          <Owner item={ model } editMode={ newArtifact }/>
        </div>

        <div className="col-xs-6 col-md-3 PlannedStartDateView">
          <TitledWell item={ model } editMode={ newArtifact } field='PlannedStartDate' label='Planned Start' inputType='date' icon='calendar'/>
        </div>
        <div className="col-xs-6 col-md-3 PlannedEndDateView">
          <TitledWell item={ model } editMode={ newArtifact } field='PlannedEndDate' label='Planned End' inputType='date' icon='calendar'/>
        </div>

        <div className="col-xs-6 col-md-3 ActualStartDateView">
          <TitledWell item={ model } editMode={ newArtifact } field='ActualStartDate' label='Actual Start' inputType='date' icon='calendar'/>
        </div>
        <div className="col-xs-6 col-md-3 ActualEndDateView">
          <TitledWell item={ model } editMode={ newArtifact } field='ActualEndDate' label='Actual End' inputType='date' icon='calendar'/>
        </div>

        <div className="col-xs-12 col-sm-6 ProjectView">
          <TitledWell item={ model } allowedValues={ this.props.allowedValues.Project } editMode={ newArtifact } field='Project' label='Project'/>
        </div>
        <div className="col-xs-12 col-sm-6 StateView">
            <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.State } editMode={ newArtifact } field="State" label="State"/>
        </div>
      
        <div className="row">
          <div className="col-xs-12 InvestmentCategoryView">
            <TitledWell item={ model } editMode={ newArtifact } field='InvestmentCategory' label='Invest Cat' allowedValues={ this.props.allowedValues.InvestmentCategory }/>
          </div>
        </div>
        {
          !newArtifact ?
            <div className="row">
              <div className="col-xs-6 col-xs-offset-3 toggle ReadyView">
                <Toggle item={ model } editMode={ newArtifact } field='Ready' label='Ready'/>
              </div>
            </div> : ''
        }
        {
          this.props.newArtifact ?
          <div>
            <div className="col-xs-2"/>
            <div className="col-xs-4 toggle display save">
              <button className="btn btn-lg btn-primary" onClick={ this.onSave }>Save</button>
            </div>
            <div className="col-xs-4 toggle display cancel">
              <button className="btn btn-lg btn-default" onClick={ this.onCancel }>Cancel</button>
            </div>
          </div> : ''
        }
      </div>
    );
  }
});
