define ->
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  Defect = require 'models/defect'
  UserStory = require 'models/user_story'
  View = require 'views/detail/defect'

  class DefectDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (id) ->
      @whenLoggedIn ->
        @fetchModelAndShowView Defect, View, id

    create: ->
      @whenLoggedIn ->
        @showCreateView Defect, View

    defectForStory: (id) ->
      @whenLoggedIn ->
        model = new UserStory(ObjectID: id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Defect for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView Defect, View, Requirement: model.attributes

    getFieldNames: ->
      [
        'FormattedID',
        'Name',
        'Owner',
        'Priority',
        'Severity',
        'State',
        'Discussion',
        'Description',
        'Blocked',
        'PlanEstimate',
        'Ready',
        'Requirement',
        'Tasks',
        app.session.get('boardField')
      ]