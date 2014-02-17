define ->
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  UserStory = require 'models/user_story'
  View = require 'views/detail/user_story'

  class UserStoryDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (id) ->
      @whenProjectIsLoaded ->
        @fetchModelAndShowView UserStory, View, id

    create: ->
      @whenProjectIsLoaded ->
        @showCreateView UserStory, View

    childForStory: (id) ->
      @whenProjectIsLoaded ->
        model = new UserStory(ObjectID: id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView UserStory, View, Parent: model.attributes

    childForPortfolioItem: (id) ->
      @whenProjectIsLoaded ->
        model = new UserStory(ObjectID: id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView UserStory, View, Parent: model.attributes

    storyForColumn: (column) ->
      @whenProjectIsLoaded ->
        props = {}
        props[app.session.get('boardField')] = column
        iterationRef = app.session.get('iteration')?.get('_ref')
        if iterationRef
          props.Iteration = iterationRef
        @updateTitle "New Story"
        @showCreateView UserStory, View, props

    getFieldNames: ->
      [
        'Blocked',
        'Children'
        'Defects',
        'Description',
        'Discussion',
        'FormattedID',
        'Name',
        'Owner',
        'Parent',
        'PlanEstimate',
        'Ready',
        'Tasks',
        app.session.get('boardField')
      ]