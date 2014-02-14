/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  		StoryBox = require ('views/wall/story_box');
  	
  return ReactView.createBackboneClass({
    render: function() {
        model = this.props.model
        var userStories = model.userStories;
        if (userStories != null) {
          var storyBoxes = _.map(userStories.models, function(userStory){
            return (
              <StoryBox model={userStory} />
            );
          }, this);
        }
        return (  
          <div className={this.getChildClass(model)}>
               <div className="grandchildren">
                  {storyBoxes}
               </div>
          </div>
      );
    },
    getChildClass: function(model) {
      return (this.allStoriesAreScheduled(model)) ? "child on" : "child";
    },
    allStoriesAreScheduled: function(model) {
      if (!model.userStories || model.userStories.length == 0) {
        return false;
      }
      return _.every(model.userStories.models, function(userStory) {
        return userStory.isScheduled();
      });
    },
    onClick: function(e) {
      var m = this.props.model;
      this.publishEvent('cardclick', m.get('ObjectID'), m.get('_type'));
      e.preventDefault();
    }
  });
});