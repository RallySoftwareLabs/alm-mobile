define [
  'hbsTemplate'
  'application'
  'views/detail/detail_view'
  'models/task'
], (hbs, app, DetailView, Task) ->

  class NewTaskView extends DetailView
    initialize: (options) ->
      options = options || {}
      options.newArtifact = true
      super options
      @delegateEvents
      Backbone.trigger "updatetitle", "New Task"

    modelType: Task
    id: 'new-task'
    template: hbs['new/templates/new_task']

    events: ->
      listeners = {}
      listeners['click #save button'] = 'onSave'
      listeners['click #cancel button'] = 'onCancel'
      listeners

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

    onSave: ->
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