define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  UserStory = require 'models/user_story'

  class NewUserStoryView extends DetailView
    newArtifact: true
    modelType: UserStory
    id: 'new-user-story'
    template: hbs['detail/templates/create_user_story']
    homeRoute: '/userstories'

    fields: [
      {'Name': 'titled_well'},
      {'Owner': 'owner'},
      {'PlanEstimate':
        view: 'titled_well'
        label: 'Plan Est'
        inputType: 'number'
      },
      {'Description': 'html'},
      {
        'ScheduleState':
          view: 'string_with_arrows'
      }
    ]

    initialize: ->
      super
      @updateTitle "New Story"
