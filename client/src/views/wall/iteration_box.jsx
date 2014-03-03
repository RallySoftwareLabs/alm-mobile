/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  moment = require('moment'),
  ReactView = require('views/base/react_view');
  StoryBox = require ('views/wall/story_box');

    
  return ReactView.createBackboneClass({
    render: function() {
      var model = this.props.model;
      var userStories = model.userStories;
      var defects = model.defects;
      var plannedVelocity = model.get('PlannedVelocity');
      var planEstimateTotal = 0;
      var unestimatedItemsCount = 0;
      var storyBoxes;
      var defectIcons;

      if (userStories != null) {
        storyBoxes = userStories.map(function(userStory) {
          var planEstimate = userStory.get('PlanEstimate');
          if (planEstimate != null) {
            planEstimateTotal += planEstimate;
          } else {
            unestimatedItemsCount += 1;
          }
          return <StoryBox model={userStory} />;
        });
      }
      if (defects != null) {
        defectIcons = defects.map(function(defect) {
          var planEstimate = defect.get('PlanEstimate');
          if (planEstimate != null) {
            planEstimateTotal += planEstimate;
          } else {
            unestimatedItemsCount += 1;
          }
          return <div className="picto icon-defect"/>;
        });
      }
      return (
        <div className="iterationBox col-xs-6 col-sm-2 col-md-2">
          <strong>{model.get('Name')}</strong><br />
          <em>{this.shortDate(model.get('StartDate'))} - {this.shortDate(model.get('EndDate'))}</em><br />
          {this.percentLoaded(planEstimateTotal,plannedVelocity,unestimatedItemsCount)}<br />
          <div className="grandchildren">
            {storyBoxes}
          </div>
          {defectIcons}       
        </div>
      );
    },
    shortDate: function(d) {
      return moment(d).format('MMM D');
    },
    loadMessage: function() {

    },
    percentLoaded: function(planEstimateTotal,plannedVelocity,unestimatedItemsCount) {
      var unestimatedItemsWarning = "";
      if (unestimatedItemsCount) {
        unestimatedItemsWarning = "with" + unestimatedItemsCount + " unestimated items.";
      }

      if (plannedVelocity == null) {
        return <span>Velocity not discussed</span>;
      } else {
        var percentLoaded = Math.round(((planEstimateTotal/plannedVelocity) * 10000)/100);
        return (
          <span>{percentLoaded}% loaded ({planEstimateTotal}/{plannedVelocity}) {unestimatedItemsWarning}
          </span>
        );
      }
    }
  });
});