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
      @whenProjectIsLoaded ->
        @fetchModelAndShowView Defect, View, id

    create: ->
      @whenProjectIsLoaded ->
        @showCreateView Defect, View

    defectForStory: (id) ->
      @whenProjectIsLoaded ->
        model = new UserStory(ObjectID: id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Defect for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView Defect, View, Requirement: model.attributes

    getFieldNames: ->
      [
        'Blocked',
        'Description',
        'Discussion',
        'FormattedID',
        'Iteration',
        'Name',
        'Owner',
        'PlanEstimate',
        'Priority',
        'Ready',
        'Release',
        'Requirement',
        'Severity',
        'State',
        'Tasks',
        app.session.get('boardField')
      ]