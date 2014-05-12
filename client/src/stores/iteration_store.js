var _ = require('underscore');
var app = require('application');
var Artifacts = require('collections/artifacts');
var PortfolioItems = require('collections/portfolio_items');
var Iteration = require('models/iteration');
var DetailStore = require('stores/detail_store');

var IterationStore = Object.create(DetailStore);

_.extend(IterationStore, {
  init: function(props) {
    this.iterationId = props.iterationId;
    this.iteration = new Iteration({ _refObjectUUID: this.iterationId });
    this.iteration.clientMetricsParent = this;
  },

  load: function() {
    var me = this;
    this.iteration.fetch({
      data: {
        shallowFetch: this.getFieldNames()
      }
    }).then(function() {
      me.trigger('change');
      return me.iteration.fetchScheduledItems();
    }).then(function(scheduledItems) {
      me.scheduledItems = scheduledItems;
      me.trigger('change');
      app.aggregator.recordComponentReady({ component: me });
    });
  },

  getModel: function() { return this.iteration; },

  getScheduledItems: function() { return this.scheduledItems; },

  getFeatures: function() {
    var features = new PortfolioItems();
    features.setSynced(true);
    
    if (this.scheduledItems) {
      this.scheduledItems.each(function(artifact) {
        var feature = artifact.get('PortfolioItem');
        if (feature && !features.some({ FormattedID: feature.FormattedID })) {
          features.add(feature, { silent: true });
        }
      });
    }
    
    return features;
  },

  getFieldNames: function() {
    return 'Name,StartDate,EndDate,PlannedVelocity,Notes,Theme,Project';
  }
});

module.exports = IterationStore;