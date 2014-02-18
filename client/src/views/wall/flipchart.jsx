/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
  		FeatureCard = require ('views/wall/feature_card');
   
  return ReactView.createBackboneClass({
    render: function() {
      var model = this.props.model;
      var features = model.features;
      if (features != null) {
        var featureCards = features.map(function(feature) {
          return <FeatureCard model={feature} />;
        });
      }
      return (
        <div className="flipchart">
          <div className="header">
            <span className="formattedID">{model.get('FormattedID')}</span><br />
            <span className="title">{model.get('Name')}</span><br />
          </div> 
          <div>
            {featureCards}
          </div>
        </div>
      );
    }
  });
});