/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
      FeatureCard = require ('views/wall/feature_card'), 
      app = require('application'),
      utils = require('lib/utils');

   
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
          <div className="header" onClick={this.onClick}>
            <span className="formattedID">{model.get('FormattedID')}</span><br />
            <span className="title">{model.get('Name')}</span><br />
          </div> 
          <div>
            {featureCards}
          </div>
        </div>
      );
    },
    onClick: function(e) {
      var m = this.props.model;
      app.aggregator.recordAction({component: this, description: "clicked flipchart header"});
      this.publishEvent('cardclick', utils.getOidFromRef(m.get('_ref')), m.get('_type'));
      e.preventDefault();
    }
  });
});
