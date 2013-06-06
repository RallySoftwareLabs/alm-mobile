define [
  'hbsTemplate'
  'application'
  'views/detail/detail_view'
  'models/user_story'
], (hbs, app, DetailView, UserStory) ->

  class NewUserStoryView extends DetailView
    newArtifact: true
    modelType: UserStory
    id: 'new-user-story'
    template: hbs['new/templates/new_user_story']
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
          view: 'string_with_arrows',
          allowedValues: [
            'Defined',
            'In-Progress',
            'Completed',
            'Accepted'
          ]
      }
    ]

    initialize: ->
      super
      @updateTitle "New Story"
