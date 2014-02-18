/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
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
               <div className="grandchildren">
                  {storyBoxes}
               </div>
          </div>
      );
    },
    getChildClass: function(userStories) {
      return (userStories && userStories.areAllStoriesScheduled()) ? "child on" : "child";
    },
    onClick: function(e) {
      var m = this.props.model;
      this.publishEvent('cardclick', m.get('ObjectID'), m.get('_type'));
      e.preventDefault();
    }
  });
});