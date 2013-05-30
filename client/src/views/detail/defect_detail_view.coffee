define [
  'views/detail/detail_view'
  'models/defect'
  'collections/defects'
], (DetailView, Defect, Defects) ->

  DetailView.extend({
    modelType: Defect
    id: 'defect-detail-view'
    template: JST['detail/templates/defect_detail']
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