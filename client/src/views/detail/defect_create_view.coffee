define [
  'hbsTemplate'
  'application'
  'views/detail/detail_view'
  'models/defect'
], (hbs, app, DetailView, Defect) ->

  class NewDefectView extends DetailView
    initialize: (options) ->
      options = options || {}
      options.newArtifact = true
      super options
      @delegateEvents
      @publishEvent "updatetitle", "New Defect"

    modelType: Defect
    id: 'new-defect'
    template: hbs['new/templates/new_defect']

    events: ->
      listeners = {}
      listeners['click #save button'] = 'onSave'
      listeners['click #cancel button'] = 'onCancel'
      listeners

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

    onSave: ->
      @model.sync 'create', @model,
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
          @trigger('save', @options.field, model)
          @publishEvent '!router:route', '', replace: false
        error: =>
          opts?.error?(model, resp, options)
          debugger

    onCancel: ->
      @publishEvent '!router:route', '', replace: false
