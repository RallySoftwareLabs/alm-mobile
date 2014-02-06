/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		Child = require ('views/wall/child'),
      Features = require('collections/features');

  return ReactView.createChaplinClass({
    render: function() {
      var model = this.props.model;
      var features = model.features;
      console.log(features);
      if (features != null) {
        var childNodes = _.map(features.models, function(feature) {
          return (
              <Child formattedID={feature.attributes.FormattedID}>
                {feature.attributes.Name}
              </Child>
          );     
        }, this);
      }
      return (
        <div className="flipchart">
          <div className="header">
            <span className="formattedID">{model.attributes.FormattedID}</span><br />
            <span className="title">{model.attributes.Name}</span><br />
          </div> 
          <div>
            {childNodes}
          </div>
        </div>
      );
    }
  });
});