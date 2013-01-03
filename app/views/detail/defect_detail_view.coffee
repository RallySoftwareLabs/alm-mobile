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
    {
      'Severity':
        view: 'titled_well'
        label: 'Severity'
        allowedValues: [
          'None'
          'Crash/Data Loss'
          'Major Problem'
          'Minor Problem'
          'Cosmetic'
        ]
    },
    {
      'Priority':
        view: 'titled_well'
        label: 'Priority'
        allowedValues: [
          'None'
          'Resolve Immediately'
          'High Attention'
          'Normal'
          'Low'
        ]
    },
    {'Discussion': 'discussion'},
    {'Description': 'html'},
    {
      'State':
        view: 'string_with_arrows'
        allowedValues: [
          'Submitted',
          'Open',
          'Fixed',
          'Closed'
        ]
    },
    {'Requirement': 'work_product'},
    'DisplayName',
    {
      'Blocked':
        view: 'toggle'
        value: 'Blocked'
    },
    {
      'Ready':
        view: 'toggle'
        value: 'Ready'
    }
  ]
})