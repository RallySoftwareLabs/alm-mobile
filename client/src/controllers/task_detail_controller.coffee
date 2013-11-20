define ->
  SiteController = require 'controllers/base/site_controller'
  Task = require 'models/task'
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