/** @jsx React.DOM */
var React = require('react');
var ReactView = require('views/base/react_view');
var DetailMixin = require('views/detail/detail_mixin');
var Description = require('views/field/description');
var Discussion = require('views/field/discussion');
var Name = require('views/field/name');
var Owner = require('views/field/owner');
var WorkProduct = require('views/field/work_product');
var TitledWell = require('views/field/titled_well');
var StringWithArrows = require('views/field/string_with_arrows');

module.exports = ReactView.createBackboneClass({
  mixins: [DetailMixin],
  render: function() {
    var model = this.props.model,
        newArtifact = !model.get('_ref');
    return (
      <div className="detail-view">
        <div className="row">
          <div className="col-xs-12 NameView">
            <Name item={ model } editMode={ newArtifact }/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-12 WorkProductView">
            <WorkProduct item={ model } editMode={ newArtifact } field="WorkProduct"/>
          </div>
        </div>
        <div className="row">
          <div className="col-xs-8 StateView">
            <StringWithArrows item={ model } allowedValues={ this.props.allowedValues.State } editMode={ newArtifact } field="State" label="State"/>
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
