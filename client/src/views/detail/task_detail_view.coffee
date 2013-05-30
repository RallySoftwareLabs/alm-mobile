define [
  'views/detail/detail_view'
  'models/task'
  'collections/tasks'
], (DetailView, Task, Tasks) ->

  DetailView.extend({
    modelType: Task
    id: 'task-detail-view'
    template: JST['detail/templates/task_detail']
    fields: [
      'FormattedID',
      {'Name': 'header'},
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
          icon: 'task-todo'
          inputType: 'number'
      },
      {'Discussion': 'discussion'},
      {'Tasks': 'tasks'},
      {'Defects': 'defects'},
      {'Description': 'html'},
      {
        'State':
          view: 'string_with_arrows',
          allowedValues: [
            'Defined',
            'In-Progress',
            'Completed'
          ]
      },
      {'WorkProduct': 'work_product'},
      'DisplayName'
    ]
  })