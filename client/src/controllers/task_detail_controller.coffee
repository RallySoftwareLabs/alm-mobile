SiteController = require 'controllers/base/site_controller'
Defect = require 'models/defect'
Task = require 'models/task'
UserStory = require 'models/user_story'
DetailControllerMixin = require 'controllers/detail_controller_mixin'
View = require 'views/detail/task'

module.exports = class TaskDetailController extends SiteController

  _.extend @prototype, DetailControllerMixin

  show: (id) ->
    @whenProjectIsLoaded ->
      @fetchModelAndShowView Task, View, id

  create: ->
    @whenProjectIsLoaded ->
      @showCreateView Task, View

  taskForDefect: (id) ->
    @whenProjectIsLoaded ->
      model = new Defect(ObjectID: id)
      model.fetch
        data:
          fetch: 'FormattedID'
        success: (model, response, opts) =>
          @updateTitle "New Task for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @showCreateView Task, View, WorkProduct: model.attributes

  taskForStory: (id) ->
    @whenProjectIsLoaded ->
      model = new UserStory(ObjectID: id)
      model.fetch
        data:
          fetch: 'FormattedID'
        success: (model, response, opts) =>
          @updateTitle "New Task for #{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @showCreateView Task, View, WorkProduct: model.attributes

  getFieldNames: ->
    [
      'FormattedID'
      'Name'
      'Owner'
      'Estimate'
      'Project'
      'ToDo'
      'State'
      'Discussion'
      'Description'
      'Blocked'
      'Ready'
      'WorkProduct[FormattedID]'
    ]