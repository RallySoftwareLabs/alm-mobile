/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
      app = require('application'),
      utils = require('lib/utils'),
      StoryBox = require ('views/wall/story_box');
  	
  return ReactView.createBackboneClass({
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
          <div className={this.getChildClass(userStories)} onClick={this.onClick}>
               <div className="header">{model.get('FormattedID')}</div>
               <div className="storyBoxes">
                  {storyBoxes}
               </div>
          </div>
      );
    },
    getChildClass: function(userStories) {
      return (userStories && userStories.areAllStoriesScheduled()) ? "featureCard on" : "featureCard";
    },
    onClick: function(e) {
      var m = this.props.model;
      app.aggregator.recordAction({component: this, description: "clicked feature card"});
      this.publishEvent('cardclick', utils.getOidFromRef(m.get('_ref')), m.get('_type'));
      e.preventDefault();
    }
  });
});