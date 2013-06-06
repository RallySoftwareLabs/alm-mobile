define [
  'underscore'
  'application'
  'views/base/page_view'
  'views/field/field_view'
  'views/field/field_discussion_view'
  'views/field/field_header_view'
  'views/field/field_html_view'
  'views/field/field_input_view'
  'views/field/field_owner_view'
  'views/field/field_string_with_arrows_view'
  'views/field/field_titled_well_view'
  'views/field/field_toggle_view'
  'views/field/field_work_product_view'
], (_, app, PageView, FieldView) ->

  class DetailView extends PageView
    region: 'main'

    events:
      'click #save button': 'onSave'
      'click #cancel button': 'onCancel'

    initialize: (options) ->
      @fieldViews = {}
      @model = if @newArtifact then new @modelType() else new @modelType(ObjectID: options.oid)
      super options
      @modelLoaded = false

      unless @newArtifact
        @model.fetch
          data:
            fetch: ['ObjectID'].concat(@_getFieldNames()).join ','
          success: (model, response, opts) =>
            @modelLoaded = true
            @updateTitle "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"

    getTemplateData: ->
      model: @model.toJSON()

    afterRender: ->
      @renderField field for field in @fields

    fieldIsEditable: (field) ->
      _.contains(@_getFieldNames(), field) && !_.contains(['FormattedID'], field)

    renderField: (field) ->
      fieldConfig = @_getFieldInfo(field)
      fieldName = fieldConfig.fieldName

      _.assign fieldConfig,
        autoRender: true
        container: @$("##{fieldConfig.fieldName}View")
        model: @model
        field: fieldConfig.fieldName
        detailView: @
        session: @options.session
        newArtifact: @newArtifact
        editable: @fieldIsEditable(fieldName)

      FieldViewClass = @_getFieldViewClass fieldConfig.viewType

      fieldView = new FieldViewClass fieldConfig

      @subview fieldName, fieldView
      
      @listenTo fieldView, 'save', @_onFieldSave

    # New artifact events

    onSave: ->
      @model.set Project: app.session.project.get('_ref')
      @model.sync 'create', @model,
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
          @trigger('save', @options.field, model)
          @publishEvent '!router:route', @homeRoute, replace: false
        error: =>
          opts?.error?(model, resp, options)
          debugger

    onCancel: ->
      @publishEvent '!router:route', @homeRoute, replace: false

    _getFieldViewClass: (viewType) ->
      try
        dynamicFieldView = require "views/field/field_#{viewType}_view"
      catch e
        dynamicFieldView = FieldView

      dynamicFieldView

    _onFieldSave: (field, model) ->
      @trigger 'fieldSave', field, model

    _getFieldInfo: (field) ->
      fieldInfo = {}
      if typeof field is 'object'
        [fieldInfo.fieldName, viewType] = ([key, value] for key, value of field)[0]
        fieldInfo.viewType = viewType
        if typeof fieldInfo.viewType is 'object'
          _.assign fieldInfo,
            label: viewType.label
            fieldValue: viewType.value
            allowedValues: viewType.allowedValues
            viewType: viewType.view
            icon: viewType.icon
            inputType: viewType.inputType
        else
          fieldInfo.label = fieldInfo.fieldName
      else
        _.assign fieldInfo,
          fieldName: field
          viewType: null
          label: field
      fieldInfo

    _getFieldNames: ->
      (@_getFieldInfo(field).fieldName for field in @fields)
