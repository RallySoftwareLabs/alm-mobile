define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  Task = require 'models/task'

  class TaskShowView extends DetailView
    modelType: Task
    id: 'task-detail-view'
    template: hbs['detail/templates/task_show']
    getFields: ->
      [
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
            icon: 'to-do'
            inputType: 'number'
        },
        {'Discussion': 'discussion'},
        {'Tasks': 'tasks'},
        {'Defects': 'defects'},
        {'Description': 'html'},
        {
          'State':
            view: 'string_with_arrows'
            label: 'State'
        },
        {'WorkProduct': 'work_product'},
        'DisplayName'
      ]
