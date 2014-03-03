/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
      _ = require('underscore'),
      React = require('react'),
      app = require('application'),
      ReactView = require('views/base/react_view'),
      DetailMixin = require('views/detail/detail_mixin'),
      Children = require('views/field/children'),
      Description = require('views/field/description'),
      Discussion = require('views/field/discussion'),
      Name = require('views/field/name'),
      Owner = require('views/field/owner'),
      TitledWell = require('views/field/titled_well'),
      Toggle = require('views/field/toggle'),
      StringWithArrows = require('views/field/string_with_arrows'),
      WorkProduct = require('views/field/work_product');

  return ReactView.createBackboneClass({
    mixins: [DetailMixin],
    render: function() {
      var model = this.props.model,
          newArtifact = this.props.newArtifact;
      return (
        <div className="detail-view">
          <div className="row">
            <div className="col-xs-12 NameView">
              <Name item={ model } editMode={ newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 DescriptionView">
              <Description item={ model } editMode={ newArtifact }/>
            </div>
          </div>

          <div className="row">
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
          </div>

          <div className="row">
            <div className="col-xs-6 col-md-2 PlannedStartDateView">
              <TitledWell item={ model } editMode={ newArtifact } field='PlannedStartDate' label='Planned Start' inputType='date' icon='calendar'/>
            </div>
            <div className="col-xs-6 col-md-2 PlannedEndDateView">
              <TitledWell item={ model } editMode={ newArtifact } field='PlannedEndDate' label='Planned End' inputType='date' icon='calendar'/>
            </div>
          </div>

          <div className="row">
            <div className="col-xs-6 col-md-2 ActualStartDateView">
              <TitledWell item={ model } editMode={ newArtifact } field='ActualStartDate' label='Actual Start' inputType='date' icon='calendar'/>
            </div>
            <div className="col-xs-6 col-md-2 ActualEndDateView">
              <TitledWell item={ model } editMode={ newArtifact } field='ActualEndDate' label='Actual End' inputType='date' icon='calendar'/>
            </div>
          </div>

            <div className="col-xs-12 col-sm-6 ProjectView">
              <TitledWell item={ model } allowedValues={ this.props.allowedValues.Project } editMode={ newArtifact } field='Project' label='Project'/>
            </div>
            <div className="col-xs-12 col-sm-6 StateView">
                <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.State } editMode={ newArtifact } field="State" label="State"/>
            </div>
           
        
          <div className="row">
            <div className="col-xs-4 InvestmentCategoryView">
              <TitledWell item={ model } editMode={ newArtifact } field='InvestmentCategory' label='Invest Cat' allowedValues={ this.props.allowedValues.InvestmentCategory }/>
            </div>
          </div>
          {
            !newArtifact ?
            <div className="row">
              <div className="col-xs-3"/>
              <div className="col-xs-6 toggle ReadyView">
                <Toggle item={ model } editMode={ newArtifact } field='Ready' label='Ready'/>
              </div>
            </div> : ''
          }
          {
            this.props.newArtifact ?
            <div className="row">
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
});