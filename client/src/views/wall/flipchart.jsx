/** @jsx React.DOM */
define(function() {
  var React = require('react'),
      ReactView = require('views/base/react_view'),
      app = require('application'),
      utils = require('lib/utils'),
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
          <div className="header" onClick={ this._onHeaderClick }>
            <span className="formatted-id">{model.get('FormattedID')}</span><br />
            <span className="title">{model.get('_refObjectName')}</span><br />
          </div> 
          <div>
            {featureCards}
          </div>
        </div>
      );
    },

    _onHeaderClick: function(e) {
      app.aggregator.recordAction({component: this, description: 'clicked card'});
      this.publishEvent('headerclick', this, this.props.model);
      e.preventDefault();
    }
  });
});