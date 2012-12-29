DetailView = require('views/detail/detail_view')
template = require('./templates/user_story_detail')
UserStory = require 'models/user_story'
UserStoryCollection = require 'models/user_story_collection'

module.exports = DetailView.extend({
  modelType: UserStory
  id: 'user-story-detail-view'
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