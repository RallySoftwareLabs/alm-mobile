define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  Task = require 'models/task'

  class NewTaskView extends DetailView
    newArtifact: true
    modelType: Task
    id: 'new-task'
    template: hbs['detail/templates/create_task']
    homeRoute: '/tasks'

    fields: [
      # ToDo: Project and WorkProduct NEED to be set
      {'Name': 'titled_well'},
      {
        'State':
          view: 'string_with_arrows'
          label: 'State'
      },
      {'Owner': 'owner'},
      {
        'Estimate':
          view: 'titled_well'
          label: 'Task Est (H)'
          inputType: 'number'
      },
      {
        'ToDo':
          view: 'titled_well'
          label: 'Task To Do (H)'
          inputType: 'number'
          icon: 'task-todo'
      },
      {'Description': 'html'}
    ]

    initialize: ->
      super
      @updateTitle "New Task"
