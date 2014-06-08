app = require 'application'
SiteController = require 'controllers/base/site_controller'
DetailControllerMixin = require 'controllers/detail_controller_mixin'
PortfolioItem = require 'models/portfolio_item'
UserStory = require 'models/user_story'
View = require 'views/detail/user_story'

module.exports = class UserStoryDetailController extends SiteController

  _.extend @prototype, DetailControllerMixin

  show: (id) ->
    @whenProjectIsLoaded().then =>
      @fetchModelAndShowView UserStory, View, id

  create: ->
    @whenProjectIsLoaded().then =>
      @showCreateView UserStory, View

  childForStory: (id) ->
    @whenProjectIsLoaded().then =>
      model = new UserStory(_refObjectUUID: id)
      model.fetch
        data:
          fetch: 'FormattedID'
        success: (model, response, opts) =>
          @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @showCreateView UserStory, View, Parent: model.attributes

  childForPortfolioItem: (id) ->
    @whenProjectIsLoaded().then =>
      model = new PortfolioItem(_refObjectUUID: id)
      model.fetch
        data:
          fetch: 'FormattedID'
        success: (model, response, opts) =>
          @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @showCreateView UserStory, View, PortfolioItem: model.attributes

  storyForColumn: (column) ->
    @whenProjectIsLoaded().then =>
      props = {}
      props[app.session.getBoardField()] = column
      iterationRef = app.session.get('iteration')?.get('_ref')
      if iterationRef
        props.Iteration = iterationRef
      @updateTitle "New Story"
      @showCreateView UserStory, View, props

  getFieldNames: ->
    _.uniq([
      'Blocked'
      'Children'
      'Defects'
      'Description'
      'Discussion'
      'FormattedID'
      'Iteration'
      'Name'
      'Owner'
      'Parent[FormattedID]'
      'PlanEstimate'
      'PortfolioItem[FormattedID]'
      'Project'
      'Ready'
      'Release'
      'ScheduleState'
      'Tasks'
      app.session.getBoardField()
    ])