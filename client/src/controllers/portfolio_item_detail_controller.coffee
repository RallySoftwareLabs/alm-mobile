app = require 'application'
SiteController = require 'controllers/base/site_controller'
DetailControllerMixin = require 'controllers/detail_controller_mixin'
View = require 'views/detail/portfolio_item'
PortfolioItem = require 'models/portfolio_item'

module.exports = class PortfolioItemDetailController extends SiteController

  _.extend @prototype, DetailControllerMixin

  show: (id) ->
    @whenProjectIsLoaded().then =>
      @fetchModelAndShowView PortfolioItem, View, id

  create: ->
    @whenProjectIsLoaded().then =>
      @showCreateView PortfolioItem, View

  newChild: (id) ->
    @whenProjectIsLoaded().then =>
      model = new PortfolioItem(_refObjectUUID: id)
      model.fetch
        data:
          fetch: 'FormattedID,Children'
        success: (model, response, opts) =>
          @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          newModel = @showCreateView PortfolioItem, View, Parent: model.get('_ref')
          newModel.urlRoot = model.urlRoot.replace('portfolioitem', model.get('Children')._type.toLowerCase())
  getFieldNames: ->
    [
      'ActualStartDate'
      'ActualEndDate'
      'Children'
      'UserStories'
      'Description'
      'Discussion'
      'FormattedID'
      'InvestmentCategory'
      'Name'
      'Owner'
      'Parent[FormattedID]'
      'PlannedStartDate'
      'PlannedEndDate'
      'PreliminaryEstimate'
      'Project'
      'Ready'
      'State'
    ]