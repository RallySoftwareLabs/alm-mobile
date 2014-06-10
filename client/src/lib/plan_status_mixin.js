module.exports = {
  planStatus: function(userStory) {
    if (userStory) {
      return this.isCompleted(userStory) ?
        'completed' :
        this.isScheduled(userStory) ?
          'scheduled' :
          'unscheduled';
    }
  },
  
  isCompleted: function(userStory) {
    return _.contains(['Accepted', 'Released'], userStory.get('ScheduleState'));
  },
    
  isScheduled: function(userStory) {
    return userStory.get('Release') || userStory.get('Iteration');
  },

  collectionPlanStatus: function(collection) {
    if (!collection || collection.isEmpty()) {
      return 'unscheduled';
    }
    var allScheduled = collection.every(function(userStory) {
      return this.isScheduled(userStory);
    }, this);
    if (allScheduled) {
      return 'scheduled';
    }
  },

  iterationPlanStatus: function(iteration) {
    if (this.loadFactor(iteration) > .1) {
      return 'overloaded';
    }
    if (!iteration.get('plannedVelocity')) {
      return 'sketchy';
    }
  },

  loadPercentage: function(iteration) {
    if (iteration.get('PlannedVelocity')) {
      var loadFactor = this.planEstimateTotal(iteration) / iteration.get('PlannedVelocity');
      return Math.round(loadFactor * 100);
    }
    return 0;
  },
      
  planEstimateTotal: function(iteration) {
    if (iteration.artifacts) {
      return iteration.artifacts.reduce(function(total, artifact) {
        return total + artifact.get('PlanEstimate') || 0;
      }, 0);
    }
    return 0;
  },

  loadStatus: function(iteration) {
    var percentage = this.loadPercentage(iteration);
    return (percentage > 100) ?
      'overloaded' :
      (percentage > 70) ?
        'high' :
        (percentage > 40) ?
          'responsive' :
          'unknown';
  }
};
