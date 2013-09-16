define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  UserStory = require 'models/user_story'

  class UserStoryShowView extends DetailView
    modelType: UserStory
    id: 'user-story-detail-view'
    template: hbs['detail/templates/user_story_show']

    getFields: ->
      [
        'FormattedID',
        {Name: 'header'},
        {Owner: 'owner'},
        {PlanEstimate:
          view: 'titled_well'
          label: 'Plan Est'
          inputType: 'number'
        },
        {Tasks: 'tasks'},
        {Defects: 'defects'},
        {Discussion: 'discussion'},
        {Description: 'html'},
        'DisplayName',
        {
          Blocked:
            view: 'toggle'
            icon: 'blocked'
        },
        {
          Ready:
            view: 'toggle'
            icon: 'ready'
        },
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