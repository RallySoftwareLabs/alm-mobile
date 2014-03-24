/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
      app = require('application'),
      utils = require('lib/utils'),
      PlanStatusMixin = require ('lib/plan_status_mixin'),
      StoryBox = require ('views/wall/story_box');
    
  return ReactView.createBackboneClass({
    mixins: [PlanStatusMixin],
    render: function() {
        var model = this.props.model;
        var userStories = model.userStories;
        var storyBoxes;

        if (userStories != null) {
          storyBoxes = userStories.map(function(userStory) {
            return <StoryBox model={userStory} />;
          });
        }
        return (  
          <div className={'featureCard ' + this.collectionPlanStatus(this.props.model.userStories)} onClick={this.onClick}>
               <div className="header">{model.get('FormattedID')}</div>
               <div className="storyBoxes">
                  {storyBoxes}
               </div>
          </div>
      );
    },
    onClick: function(e) {
      var m = this.props.model;
      app.aggregator.recordAction({component: this, description: "clicked feature card"});
      this.publishEvent('cardclick', utils.getOidFromRef(m.get('_ref')), m.get('_type'));
      e.preventDefault();
    }
  });
});