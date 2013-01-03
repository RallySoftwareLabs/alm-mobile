View = require 'views/view'
FieldView = require 'views/field/field_view'

module.exports = class DetailView extends View
  initialize: (options) ->
    debugger
    super options
    @_defineFieldEditFns field for field in @_getFieldNames()
    @fieldViews = {}
    @model = new @modelType(ObjectID: options.oid)
    @model.fetch({
      data:
        fetch: ['ObjectID'].concat(@_getFieldNames()).join ','
      success: (model, response, opts) =>
        @delegateEvents()
        @render() if options.autoRender
    })

  events: ->
    listeners = {}
    listeners["click ##{key}View.display"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
    listeners

  getRenderData: ->
    model: @model.toJSON()

  afterRender: ->
    @renderField field for field in @fields

  remove: ->
    super
    fieldView.remove() for key, fieldView of @fieldViews

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
    FieldViewClass = @_getFieldViewClass fieldConfig.viewType
    @fieldViews[fieldConfig.fieldName] = fieldView = new FieldViewClass(fieldConfig).render()

    fieldView.on('save', @_onFieldSave, @)

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
      else
        fieldInfo.label = fieldInfo.fieldName
    else
      fieldInfo.fieldName = field
      fieldInfo.viewType = null
      fieldInfo.label = field
    fieldInfo

  _getFieldNames: ->
    (@_getFieldInfo(field).fieldName for field in @fields)
    