DetailView = require('views/detail/detail_view')
template = require('./templates/defect_detail')
Defect = require 'models/defect'
DefectCollection = require 'models/defect_collection'

module.exports = DetailView.extend({
  modelType: Defect
  id: 'defect-detail-view'
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