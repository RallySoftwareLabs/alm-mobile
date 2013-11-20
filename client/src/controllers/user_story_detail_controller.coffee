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

    getFieldNames: ->
      [
        'FormattedID',
        'Name',
        'Owner',
        'PlanEstimate',
        'Tasks',
        'Defects',
        'Discussion',
        'Description',
        'Blocked',
        'Ready',
        app.session.get('boardField')
      ]