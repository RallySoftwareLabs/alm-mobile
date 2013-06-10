define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  UserStory = require 'models/user_story'

  class UserStoryShowView extends DetailView
    modelType: UserStory
    id: 'user-story-detail-view'
    template: hbs['detail/templates/user_story_detail']
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
          view: 'string_with_arrows'
          label: 'Schedule State'
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
