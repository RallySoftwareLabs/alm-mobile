define ->
  SiteController = require 'controllers/base/site_controller'
  Defect = require 'models/defect'
  Task = require 'models/task'
  UserStory = require 'models/user_story'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  View = require 'views/detail/task'

  class TaskDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (id) ->
      @whenLoggedIn ->
        @fetchModelAndShowView Task, View, id

    create: ->
      @whenLoggedIn ->
        @showCreateView Task, View

    taskForDefect: (id) ->
      @whenLoggedIn ->
        model = new Defect(ObjectID: id)
        model.fetch
          data:
            fetch: 'FormattedID'
          success: (model, response, opts) =>
            @updateTitle "New Task for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
            @showCreateView Task, View, WorkProduct: model.attributes

    taskForStory: (id) ->
      @whenLoggedIn ->
        model = new UserStory(ObjectID: id)
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