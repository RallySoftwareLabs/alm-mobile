DetailView = require('views/detail/detail_view')
template = require('./templates/task_detail')
Task = require 'models/task'
TaskCollection = require 'models/task_collection'

module.exports = DetailView.extend({
  modelType: Task
  id: 'task-detail-view'
  template: template
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