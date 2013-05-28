define ['views/detail/detail_view', 'models/user_story'], (DetailView, UserStory) ->

  DetailView.extend({
    modelType: UserStory
    id: 'user-story-detail-view'
    template: JST['detail/templates/user_story_detail']
    fields: [
      'FormattedID',
      {'Name': 'header'},
      {'Owner': 'owner'},
      {'PlanEstimate':
        view: 'titled_well'
        label: 'Plan Est'
        inputType: 'number'
      },
      {'Tasks': 'tasks'},
      {'Defects': 'defects'},
      {'Discussion': 'discussion'},
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
      },
      'DisplayName',
      {
        'Blocked':
          view: 'toggle'
      },
      {
        'Ready':
          view: 'toggle'
      }
    ]
  })