/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
  		_ = require('underscore'),
			React = require('react'),
			app = require('application'),
  		ReactView = require('views/base/react_view'),
      DetailMixin = require('views/detail/detail_mixin'),
  		Defects = require('views/field/defects'),
  		Description = require('views/field/description'),
  		Discussion = require('views/field/discussion'),
  		Name = require('views/field/name'),
      Owner = require('views/field/owner'),
  		Tasks = require('views/field/tasks'),
      WorkProduct = require('views/field/work_product'),
  		TitledWell = require('views/field/titled_well'),
  		Toggle = require('views/field/toggle'),
  		StringWithArrows = require('views/field/string_with_arrows');

  return ReactView.createChaplinClass({
    mixins: [DetailMixin],
  	render: function() {
  		return (
  			<div className="detail-view">
  			  <div className="row">
  			    <div className="col-xs-12 NameView">
  			  		<Name item={ this.props.model } editMode={ this.props.newArtifact }/>
  			    </div>
  			  </div>
          <div className="row">
            <div className="col-xs-12 ellipsis RequirementView">
              <WorkProduct item={ this.props.model } editMode={ this.props.newArtifact } field="Requirement"/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-8">
              <div className="row">
                <div className="col-xs-12 ScheduleStateView">
                  <StringWithArrows item={ this.props.model } editMode={ this.props.newArtifact } field={ app.session.get('boardField') } label={ this.getScheduleStateLabel() }/>
                </div>
              </div>
              <div className="row">
                <div className="col-xs-12 StateView">
                  <StringWithArrows item={ this.props.model } editMode={ this.props.newArtifact } field="State" label="State"/>
                </div>
              </div>
            </div>
            <div className="col-xs-4 OwnerView">
              <Owner item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-4 PlanEstimateView">
              <TitledWell item={ this.props.model } editMode={ this.props.newArtifact } field='PlanEstimate' label='Plan Est' inputType='number'/>
            </div>
            <div className="col-xs-4 TasksView">
              <Tasks item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
            <div className="col-xs-4 DiscussionView">
              <Discussion item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-6 SeverityView">
              <TitledWell item={ this.props.model } editMode={ this.props.newArtifact } field='Severity' label='Severity'/>
            </div>
            <div className="col-xs-6 PriorityView">
              <TitledWell item={ this.props.model } editMode={ this.props.newArtifact } field='Priority' label='Priority'/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-12 DescriptionView">
              <Description item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          {
            !this.props.newArtifact ?
            <div className="row">
              <div className="col-xs-1"/>
              <div className="col-xs-5 toggle BlockedView">
                <Toggle item={ this.props.model } editMode={ this.props.newArtifact } field='Blocked' label='Blocked'/>
              </div>
              <div className="col-xs-5 toggle ReadyView">
                <Toggle item={ this.props.model } editMode={ this.props.newArtifact } field='Ready' label='Ready'/>
              </div>
              <div className="col-xs-1"/>
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
  	},

  	getScheduleStateLabel: function() {
  		return (app.session.get('boardField') == 'ScheduleState') ? 'Schedule State' : 'Kanban State';
  	}
  });
});