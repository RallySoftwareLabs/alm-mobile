_ = require 'underscore'
app = require 'application'
Artifacts = require 'collections/artifacts'
PortfolioItems = require 'collections/portfolio_items'
Iteration = require 'models/iteration'
DetailStore = require 'stores/detail_store'

module.exports = class IterationStore extends DetailStore
  constructor: ({@iterationId}) ->
    @iteration = new Iteration(_refObjectUUID: @iterationId)
    @iteration.clientMetricsParent = this

  load: ->
    @iteration.fetch(
      data:
        shallowFetch: @getFieldNames()
    ).then =>
      @trigger 'change'
      @iteration.fetchScheduledItems().then (@scheduledItems) =>
        @trigger 'change'
        app.aggregator.recordComponentReady component: this

  getModel: -> @iteration

  getScheduledItems: -> @scheduledItems

  getFeatures: ->
    features = new PortfolioItems()
    features.setSynced true
    
    @scheduledItems?.each (artifact) ->
      feature = artifact.get('PortfolioItem')
      if feature? && !features.some(FormattedID: feature.FormattedID)
        features.add(feature, silent: true)
    
    features

  getFieldNames: ->
    'Name,StartDate,EndDate,PlannedVelocity,Notes,Theme,Project'
