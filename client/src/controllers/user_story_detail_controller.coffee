define ->
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  UserStory = require 'models/user_story'
  View = require 'views/detail/user_story'

  class UserStoryDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (params) ->
      @whenLoggedIn ->
        @fetchModelAndShowView UserStory, View, params.id

    create: (params) ->
      @whenLoggedIn ->
        @showCreateView UserStory, View

    childForStory: (params) ->
      @whenLoggedIn ->
        model = new UserStory(ObjectID: params.id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Child for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView UserStory, View, Parent: model.attributes

    storyForColumn: (params) ->
      @whenLoggedIn ->
        props = {}
        props[app.session.get('boardField')] = params.column
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