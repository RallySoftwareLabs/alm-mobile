/** @jsx React.DOM */
define(function() {
  var React = require('react'),
  		_ = require('underscore'),
  		app = require('application'),
  		utils = require('lib/utils'),
  		FeatureCard = require ('views/wall/feature_card');
   
  return ReactView.createChaplinClass({
    render: function() {
      var model = this.props.model;
      var features = model.features;
      if (features != null) {
        var featureCards = _.map(features.models, function(feature) {
          return (
              <FeatureCard model={feature} />
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
            {featureCards}
          </div>
        </div>
      );
    }
  });
});