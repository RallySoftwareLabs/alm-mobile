/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils');
  		StoryBox = require ('views/wall/story_box');
  	
  return ReactView.createChaplinClass({
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
               <div className="header">
                    <span className="formattedID">{model.attributes.FormattedID}</span><br />
                    {model.attributes.Name}
               </div>
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
      //If there is 1 unscheduled, return false;
      //Otherwise return true.
      //
      // There has to be a better way! Why the nested ifs?
      //
      if (model.userStories) {
        if (model.userStories.length > 0) {
          return _.every(model.userStories.models, function(userStory) {
            return userStory.isScheduled();
          });
        }
      }
      return false;
    }


  });
});