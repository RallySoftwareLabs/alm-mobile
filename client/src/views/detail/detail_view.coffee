define ->
  _ = require 'underscore'
  app = require 'application'
  PageView = require 'views/base/page_view'
  FieldView = require 'views/field/field_view'

  # importing for Require.js optimization
  FieldDefectsView = require 'views/field/field_defects_view'
  FieldDiscussionView = require 'views/field/field_discussion_view'
  FieldHeaderView = require 'views/field/field_header_view'
  FieldHtmlView = require 'views/field/field_html_view'
  FieldInputView = require 'views/field/field_input_view'
  FieldOwnerView = require 'views/field/field_owner_view'
  FieldStringWithArrowsView = require 'views/field/field_string_with_arrows_view'
  FieldTasksView = require 'views/field/field_tasks_view'
  FieldTitledWellView = require 'views/field/field_titled_well_view'
  FieldToggleView = require 'views/field/field_toggle_view'
  FieldWorkProductView = require 'views/field/field_work_product_view'

  class DetailView extends PageView
    region: 'main'
    loadingIndicator: true

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
            fetch: ['ObjectID'].concat(@getFieldNames()).join ','
          success: (model, response, opts) =>
            @modelLoaded = true
            @updateTitle "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"

    getTemplateData: ->
      data = 
        model: @model.toJSON()

      if @getScheduleStateField?
        data.ScheduleStateFieldName = @_getFieldInfo(@getScheduleStateField()).fieldName

      data

    afterRender: ->
      @renderField field for field in @getFields()

    fieldIsEditable: (field) ->
      _.contains(@getFieldNames(), field) && !_.contains(['FormattedID'], field)

    renderField: (field) ->
      fieldConfig = @_getFieldInfo(field)
      fieldName = fieldConfig.fieldName

      _.assign fieldConfig,
        autoRender: true
        container: @$("##{fieldConfig.fieldName}View")
        model: @model
        field: fieldConfig.fieldName
        detailView: this
        session: @options.session
        newArtifact: @newArtifact
        editable: @fieldIsEditable(fieldName)

      FieldViewClass = @_getFieldViewClass fieldConfig.viewType

      fieldView = new FieldViewClass fieldConfig

      @subview fieldName, fieldView
      
      @listenTo fieldView, 'save', @_onFieldSave

    # New artifact events

    onSave: ->
      @model.set Project: app.session.get('project').get('_ref')
      @model.sync 'create', @model,
        fetch: ['ObjectID'].concat(@getFieldNames()).join ','
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
          @trigger('save', @options.field, model)
          @publishEvent '!router:route', @homeRoute, replace: false
        error: =>
          opts?.error?(model, resp, options)

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

    getFieldNames: ->
      (@_getFieldInfo(field).fieldName for field in @getFields())
