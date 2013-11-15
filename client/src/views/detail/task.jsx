/** @jsx React.DOM */
define(function() {
  var $ = require('jquery'),
  		_ = require('underscore'),
			React = require('react'),
			app = require('application'),
  		ReactView = require('views/base/react_view'),
      DetailMixin = require('views/detail/detail_mixin'),
  		Description = require('views/field/description'),
  		Discussion = require('views/field/discussion'),
  		Name = require('views/field/name'),
  		Owner = require('views/field/owner'),
      WorkProduct = require('views/field/work_product'),
  		TitledWell = require('views/field/titled_well'),
  		Toggle = require('views/field/toggle'),
  		StringWithArrows = require('views/field/string_with_arrows');

  return ReactView.createChaplinClass({
    mixins: [DetailMixin],
  	render: function() {
  		return (
        <div class="detail-view">
          <div class="row">
            <div className="col-xs-12 NameView">
              <Name item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-12 ellipsis WorkProductView">
              <WorkProduct item={ this.props.model } editMode={ this.props.newArtifact } field="WorkProduct"/>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-8 StateView">
              <StringWithArrows item={ this.props.model } editMode={ this.props.newArtifact } field="State" label="State"/>
            </div>
            <div class="col-xs-4 OwnerView">
              <Owner item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-5 EstimateView">
              <TitledWell item={ this.props.model } editMode={ this.props.newArtifact } field='Estimate' label='Task Est (H)' inputType='number'/>
            </div>
            <div class="col-xs-5 ToDoView">
              <TitledWell item={ this.props.model } editMode={ this.props.newArtifact } field='ToDo' label='Task To Do (H)' inputType='number'/>
            </div>
            <div class="col-xs-2 DiscussionView">
              <Discussion item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-12 DescriptionView">
              <Description item={ this.props.model } editMode={ this.props.newArtifact }/>
            </div>
          </div>
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