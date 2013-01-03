DetailView = require '../detail/detail_view'
template = require './templates/new_user_story'
UserStory = require 'models/user_story'

module.exports = class NewUserStoryView extends DetailView
  initialize: (options) ->
    options = options || {}
    options['new'] = true
    options['oid'] = ""
    super options
    @delegateEvents

  modelType: UserStory
  id: '#new-user-story'
  template: template

  events: ->
    listeners = super
    listeners['click #save'] = 'onSave'
    listeners['click #cancel'] = 'onCancel'
    listeners

  fields: [
    {'Name': 'titled_well'},
    {'Owner': 'owner'},
    {'PlanEstimate':
      view: 'titled_well'
      label: 'Plan Est'
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

  onSave: ->
    console.log 'onSave'

  onCancel: ->
    console.log  'onCancel'
