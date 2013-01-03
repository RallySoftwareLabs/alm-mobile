app        = require 'application'
DetailView = require '../detail/detail_view'
template   = require './templates/new_user_story'
UserStory  = require 'models/user_story'

module.exports = class NewUserStoryView extends DetailView
  initialize: (options) ->
    options = options || {}
    options.newArtifact = true
    super options
    @delegateEvents

  modelType: UserStory
  id: '#new-user-story'
  template: template

  events: ->
    listeners = {}
    listeners['click #save button'] = 'onSave'
    listeners['click #cancel button'] = 'onCancel'
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
    # ToDo: Set project from settings
    @model.sync 'create', @model,
      wait: true
      patch: true
      success: (model, resp, options) =>
        opts?.success?(model, resp, options)
        @trigger('save', @options.field, model)
        app.router.navigate('', {trigger: true, replace: false})
      error: =>
        opts?.error?(model, resp, options)
        debugger

  onCancel: ->
    app.router.navigate('', {trigger: true, replace: false})
