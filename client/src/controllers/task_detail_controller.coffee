define ->
  SiteController = require 'controllers/base/site_controller'
  Defect = require 'models/defect'
  Task = require 'models/task'
  UserStory = require 'models/user_story'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  View = require 'views/detail/task'

  class TaskDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (params) ->
      @whenLoggedIn ->
        @fetchModelAndShowView Task, View, params.id

    create: (params) ->
      @whenLoggedIn ->
        @showCreateView Task, View

    taskForDefect: (params) ->
      @whenLoggedIn ->
        model = new Defect(ObjectID: params.id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Task for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView Task, View, WorkProduct: model.attributes

    taskForStory: (params) ->
      @whenLoggedIn ->
        model = new UserStory(ObjectID: params.id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Task for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView Task, View, WorkProduct: model.attributes

    getFieldNames: ->
      [
        'FormattedID',
        'Name',
        'Owner',
        'Estimate',
        'ToDo',
        'State',
        'Discussion',
        'Description',
        'Blocked',
        'Ready',
        'WorkProduct'
      ]