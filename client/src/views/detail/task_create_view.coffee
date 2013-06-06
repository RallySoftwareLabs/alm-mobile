define [
  'hbsTemplate'
  'application'
  'views/detail/detail_view'
  'models/task'
], (hbs, app, DetailView, Task) ->

  class NewTaskView extends DetailView
    newArtifact: true
    modelType: Task
    id: 'new-task'
    template: hbs['new/templates/new_task']
    homeRoute: '/tasks'

    fields: [
      # ToDo: Project and WorkProduct NEED to be set
      {'Name': 'titled_well'},
      {
        'State':
          view: 'string_with_arrows',
          allowedValues: [
            'Defined',
            'In-Progress',
            'Completed'
          ]
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
      @publishEvent "updatetitle", "New Task"
