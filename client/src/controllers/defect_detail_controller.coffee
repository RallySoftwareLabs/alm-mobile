define ->
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  DetailControllerMixin = require 'controllers/detail_controller_mixin'
  Defect = require 'models/defect'
  View = require 'views/detail/defect'

  class DefectDetailController extends SiteController

    _.extend @prototype, DetailControllerMixin

    show: (params) ->
      @whenLoggedIn ->
        @fetchModelAndShowView Defect, View, params.id

    create: (params) ->
      @whenLoggedIn ->
        @showCreateView Defect, View

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