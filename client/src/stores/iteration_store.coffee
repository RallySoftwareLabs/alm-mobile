_ = require 'underscore'
app = require 'application'
utils = require 'lib/utils'
Artifacts = require 'collections/artifacts'
PortfolioItems = require 'collections/portfolio_items'
Iteration = require 'models/iteration'
DetailStore = require 'stores/detail_store'

module.exports = class IterationStore extends DetailStore
  constructor: ({@iterationId}) ->
    @iteration = new Iteration(_refObjectUUID: @iterationId)
    @iteration.artifacts = new Artifacts()
    @iteration.fetch(
      data:
        shallowFetch: @getFieldNames()
    ).then =>
      @trigger 'change'
      @_fetchScheduledItems().then =>
        @trigger 'change'
        @
        @_fetchFeatures

  getModel: -> @iteration

  getFeatures: ->
    features = new PortfolioItems()
    features.setSynced true
    
    @iteration.artifacts.each (artifact) ->
      feature = artifact.get('PortfolioItem')
      if feature? && !features.find((f) -> f.FormattedID == feature.FormattedID)
        features.add(feature, silent: true)
    
    features

  getFieldNames: ->
    'Name,StartDate,EndDate,PlannedVelocity,Notes,Theme'

  _fetchScheduledItems: ->
    iterationRef = @iteration.get('_ref')
    @iteration.artifacts.fetchAllPages
      data:
        shallowFetch: 'FormattedID,Name,Release,Iteration,PlanEstimate,Blocked,PortfolioItem[FormattedID;Name]'
        types: 'hierarchicalrequirement,defect'
        query: "(((Iteration.Name = \"#{@iteration.get('Name')}\") AND (Iteration.StartDate = \"#{@iteration.get('StartDate')}\")) AND (Iteration.EndDate = \"#{@iteration.get('EndDate')}\"))"
        order: 'Rank'
        project: app.session.get('project').get('_ref')
        projectScopeUp: false
        projectScopeDown: true
