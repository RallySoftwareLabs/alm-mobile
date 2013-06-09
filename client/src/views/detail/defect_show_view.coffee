define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  Defect = require 'models/defect'

  class DefectShowView extends DetailView
    modelType: Defect
    id: 'defect-detail-view'
    template: hbs['detail/templates/defect_detail']
    fields: [
      'FormattedID',
      {'Name': 'header'},
      {'Owner': 'owner'},
      {
        'Severity':
          view: 'titled_well'
          label: 'Severity'
      },
      {
        'Priority':
          view: 'titled_well'
          label: 'Priority'
      },
      {'Discussion': 'discussion'},
      {'Description': 'html'},
      {
        'State':
          view: 'string_with_arrows'
          label: 'State'
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
