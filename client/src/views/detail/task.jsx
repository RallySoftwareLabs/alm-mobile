/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		ReactView = require('views/base/react_view'),
      DetailMixin = require('views/detail/detail_mixin'),
  		Description = require('views/field/description'),
  		Discussion = require('views/field/discussion'),
  		Name = require('views/field/name'),
  		Owner = require('views/field/owner'),
      WorkProduct = require('views/field/work_product'),
  		TitledWell = require('views/field/titled_well'),
  		StringWithArrows = require('views/field/string_with_arrows');

  return ReactView.createChaplinClass({
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
            <div className="col-xs-12 ellipsis WorkProductView">
              <WorkProduct item={ model } editMode={ newArtifact } field="WorkProduct"/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-8 StateView">
              <StringWithArrows item={ model } editMode={ newArtifact } field="State" label="State"/>
            </div>
            <div className="col-xs-4 OwnerView">
              <Owner item={ model } editMode={ newArtifact }/>
            </div>
          </div>
          <div className="row">
            <div className="col-xs-5 EstimateView">
              <TitledWell item={ model } editMode={ newArtifact } field='Estimate' label='Task Est (H)' inputType='number'/>
            </div>
            <div className="col-xs-5 ToDoView">
              <TitledWell item={ model } editMode={ newArtifact } field='ToDo' label='Task To Do (H)' inputType='number'/>
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
          { newArtifact ? this.getButtonsMarkup() : '' }
        </div>
  		);
  	}
  });
});