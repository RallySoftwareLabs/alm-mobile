DetailView = require '../detail/detail_view'
template = require './templates/new_user_story'
UserStory = require 'models/user_story'
# LoadingMaskView = require '../shared/loading_view'

module.exports = DetailView.extend
  model: new UserStory()
  id: '#new-user-story'
  template: template

  fields: [
    'FormattedID',
    {'Name': 'header'},
    {'Owner': 'owner'},
    {'PlanEstimate':
      view: 'titled_well'
      label: 'Plan Est'
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
    