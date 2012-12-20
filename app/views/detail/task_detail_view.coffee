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
    {'PlanEstimate': 'titled_well'},
    {'Tasks': 'tasks'},
    {'Defects': 'defects'},
    {'Description': 'html'},
    'ScheduleState',
    'DisplayName'
  ]
})