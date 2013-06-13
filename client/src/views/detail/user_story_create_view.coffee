define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  UserStory = require 'models/user_story'

  class NewUserStoryView extends DetailView
    newArtifact: true
    modelType: UserStory
    id: 'new-user-story'
    template: hbs['detail/templates/user_story_create']
    homeRoute: '/userstories'
    showLoadingIndicator: false

    initialize: ->
      super
      @updateTitle "New Story"

    getFields: ->
      [
        {Name: 'titled_well'},
        {Owner: 'owner'},
        {PlanEstimate:
          view: 'titled_well'
          label: 'Plan Est'
          inputType: 'number'
        },
        {Description: 'html'},
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
