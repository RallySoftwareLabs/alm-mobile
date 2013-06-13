define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  Defect = require 'models/defect'

  class NewDefectView extends DetailView
    newArtifact: true
    modelType: Defect
    id: 'new-defect'
    template: hbs['detail/templates/defect_create']
    homeRoute: '/defects'
    showLoadingIndicator: false

    initialize: ->
      super
      @updateTitle "New Defect"

    getFields: ->
      [
        {'Name': 'titled_well'},
        # add story selection
        {
          'State':
            view: 'string_with_arrows'
            label: 'State'
        },
        {'Owner': 'owner'},
        {
          'Severity':
            view: 'titled_well'
            label: 'Severity'
        },
        {
          'Priority':
            view: 'titled_well'
            label: 'Priority'
        },
        {'Description': 'html'},
        @getScheduleStateField()
      ]

    getScheduleStateField: ->
      return if app.session.get('boardField') == 'ScheduleState'
        ScheduleState:
          view: 'string_with_arrows'
          label: 'Schedule State'
      else
        c_KanbanState:
          view: 'string_with_arrows'
          label: 'Kanban State'
