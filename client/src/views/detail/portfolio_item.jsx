/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
  		_ = require('underscore'),
			React = require('react'),
			app = require('application'),
  		ReactView = require('views/base/react_view'),
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
          newArtifact = this.props.newArtifact,
          childrenOrTasks = model.get('Children') && model.get('Children').Count ?
            (
              <div className="col-xs-3 ChildrenView">
                <Children item={ model } editMode={ newArtifact }/>
              </div>
            )
            :
            (
              <div className="col-xs-3 TasksView">
                <Tasks item={ model } editMode={ newArtifact }/>
              </div>
            );
  		return (
  			<div className="detail-view">
  			  <div className="row">
  			    <div className="col-xs-12 NameView">
  			  		<Name item={ model } editMode={ newArtifact }/>
  			    </div>
  			  </div>
          <div className="row">
            <div className="col-xs-12 ellipsis ParentView">
              <WorkProduct item={ model } editMode={ newArtifact } field="Parent" label="Parent"/>
            </div>
          </div>
  			  <div className="row">
  			    <div className="col-xs-8 ScheduleStateView">
  			    	<StringWithArrows item={ model } editMode={ newArtifact } field={ app.session.get('boardField') } label={ this.getScheduleStateLabel() }/>
  			    </div>
  			    <div className="col-xs-4 OwnerView">
  			    	<Owner item={ model } editMode={ newArtifact }/>
  			    </div>
  			  </div>
  			  <div className="row">
  			    <div className="col-xs-3 PlanEstimateView">
  			    	<TitledWell item={ model } editMode={ newArtifact } field='PlanEstimate' label='Plan Est' inputType='number'/>
  			    </div>
            { childrenOrTasks }
  			    <div className="col-xs-3 DefectsView">
  			    	<Defects item={ model } editMode={ newArtifact }/>
  			    </div>
  			    <div className="col-xs-3 DiscussionView">
  			    	<Discussion item={ model } editMode={ newArtifact }/>
  			    </div>
  			  </div>
  			  <div className="row">
  			    <div className="col-xs-12 DescriptionView">
  			    	<Description item={ model } editMode={ newArtifact }/>
  			    </div>
  			  </div>
          {
            !newArtifact ?
    			  <div className="row">
    			    <div className="col-xs-1"/>
    			    <div className="col-xs-5 toggle BlockedView">
    			    	<Toggle item={ model } editMode={ newArtifact } field='Blocked' label='Blocked'/>
    			    </div>
    			    <div className="col-xs-5 toggle ReadyView">
    			    	<Toggle item={ model } editMode={ newArtifact } field='Ready' label='Ready'/>
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