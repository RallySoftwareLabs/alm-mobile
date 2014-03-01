/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  ReactView = require('views/base/react_view');
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
      var defectString
      if (model.defects != null) {
        if (model.defects.length > 0) {
          defectString = "and " + model.defects.length + " defects";
        }
      }
      return (
        <div className="iterationBox">
          {model.get('Name')}<br />
          <div className="grandchildren">
            {storyBoxes}
          </div>
          {defectString}       
        </div>
      );
    }
  });
});