define ->
  hbs = require 'hbsTemplate'
  DetailView = require 'views/detail/detail_view'
  Defect = require 'models/defect'

  class NewDefectView extends DetailView
    newArtifact: true
    modelType: Defect
    id: 'new-defect'
    template: hbs['detail/templates/create_defect']
    homeRoute: '/defects'

    fields: [
      {'Name': 'titled_well'},
      # add story selection
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
      {'Description': 'html'}
    ]

    initialize: ->
      super
      @updateTitle "New Defect"