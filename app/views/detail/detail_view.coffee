View = require 'views/view'
FieldView = require 'views/field/field_view'

module.exports = class DetailView extends View
  initialize: (options) ->
    super options
    @newArtifact = options.newArtifact? and options.newArtifact
    @_defineFieldEditFns field for field in @_getFieldNames()
    @fieldViews = {}
    @model = if @newArtifact then new @modelType() else new @modelType(ObjectID: options.oid)
    unless @newArtifact
      @model.fetch({
        data:
          fetch: ['ObjectID'].concat(@_getFieldNames()).join ','
        success: (model, response, opts) =>
          @delegateEvents()
          Backbone.trigger "updatetitle", "#{model.get('FormattedID')}: #{model.get('_refObjectName')}"
          @render() if options.autoRender
      })
    @modelLoaded = false


  events: ->
    listeners = {}
    listeners["click ##{key}View.display"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
    listeners

  getRenderData: ->
    model: @model.toJSON()

  afterRender: ->
    @_removeFieldViews()
    if @modelLoaded || @newArtifact
      @renderField field for field in @fields
    else
      @model.fetch({
        data:
          fetch: ['ObjectID'].concat(@_getFieldNames()).join ','
        success: (model, response, opts) =>
          @modelLoaded = true
          @render() if @options.autoRender
          @delegateEvents()
      })

  remove: ->
    super
    @_removeFieldViews()

  fieldIsEditable: (field) ->
    return false unless field in @_getFieldNames()
    if field in ['FormattedID'] then false else true

  renderField: (field) ->
    fieldConfig = @_getFieldInfo(field)
    fieldConfig.field = fieldConfig.fieldName
    fieldConfig.model = @model
    fieldConfig.el = this.$("##{fieldConfig.fieldName}View")
    fieldConfig.detailView = @
    fieldConfig.session = @options.session
    fieldConfig.newArtifact = @newArtifact
    FieldViewClass = @_getFieldViewClass fieldConfig.viewType
    @fieldViews[fieldConfig.fieldName] = fieldView = new FieldViewClass(fieldConfig).render()

    fieldView.on('save', @_onFieldSave, @)

  _removeFieldViews: ->
    fieldView.remove() for key, fieldView of @fieldViews

  _getFieldViewClass: (viewType) ->
    try
      dynamicFieldView = require "views/field/field_#{viewType}_view"
    catch e
      dynamicFieldView = FieldView

    dynamicFieldView

  _defineFieldEditFns: (field) ->
    unless @["startEdit#{field}"]?
      @["startEdit#{field}"] = ->
        @_startEdit(field)

  _startEdit: (field) ->
    fieldName = @_getFieldInfo(field).fieldName
    @fieldViews[fieldName].startEdit()

  _onFieldSave: (field, model) ->
    @trigger 'fieldSave', field, model

  _getFieldInfo: (field) ->
    fieldInfo = {}
    if typeof field is 'object'
      [fieldInfo.fieldName, viewType] = ([key, value] for key, value of field)[0]
      fieldInfo.viewType = viewType
      if typeof fieldInfo.viewType is 'object'
        fieldInfo.label = viewType.label
        fieldInfo.fieldValue = viewType.value
        fieldInfo.allowedValues = viewType.allowedValues
        fieldInfo.viewType = viewType.view
        fieldInfo.icon = viewType.icon
        fieldInfo.inputType = viewType.inputType
      else
        fieldInfo.label = fieldInfo.fieldName
    else
      fieldInfo.fieldName = field
      fieldInfo.viewType = null
      fieldInfo.label = field
    fieldInfo

  _getFieldNames: ->
    (@_getFieldInfo(field).fieldName for field in @fields)
