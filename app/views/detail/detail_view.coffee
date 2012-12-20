View = require 'views/view'
FieldDisplayView = require 'views/field/field_display_view'
FieldEditView = require 'views/field/field_edit_view'

DynamicFieldViews =
  'field_display_toggle_view': require 'views/field/field_display_toggle_view'

ENTER_KEY = 13

module.exports = View.extend
  initialize: (options) ->
    View.prototype.initialize.call(this, [options])
    @_defineFieldEditFns field for field in @_getFieldNames()
    @model = new @modelType(ObjectID: options.oid)
    @model.fetch({
      data:
        fetch: ['ObjectID'].concat(@_getFieldNames()).join ','
      success: (model, response, opts) =>
        @delegateEvents()
        @render() if options.autoRender
    })

  events: ->
    listeners = 
      'blur input': 'onBlur'
      'blur textarea': 'onBlur'
      'keydown input': 'onKeyDown'
      'click .clear-pill': 'onClearClick'
    listeners["click ##{key}View.display"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
    listeners

  getRenderData: ->
    edit: @options.edit
    model: @model.toJSON()

  afterRender: ->
    @renderField field for field in @fields

  onBlur: (event) ->
    @endEdit event

  onKeyDown: (event) ->
    @endEdit(event) if event.which is ENTER_KEY

  onClearClick: (event) ->
    modelUpdates = null
    if @model.get('Blocked')
      modelUpdates =
        Blocked: false
    if @model.get('Ready')
      modelUpdates ?=
        Ready: false
    @_saveModel modelUpdates if modelUpdates?

  endEdit: (event) ->
    value = event.target.value
    field = event.target.id
    event.preventDefault()
    if @model.get(field) isnt value
      modelUpdates = {}
      modelUpdates[field] = value
      @_saveModel modelUpdates
    else
      @_switchToViewMode()

  fieldIsEditable: (field) ->
    return false unless field in @_getFieldNames()
    if field in ['FormattedID'] then false else true

  _defineFieldEditFns: (field) ->
    unless @["startEdit#{field}"]?
      @["startEdit#{field}"] = ->
        @_startEdit(field)

  renderField: (field) ->
    [fieldName, viewType, label, value] = @_getFieldInfo(field)
    if @options.edit is fieldName
      dynamicView = DynamicFieldViews["field_edit_#{viewType}_view"]
      FieldViewClass = dynamicView || FieldEditView
    else
      dynamicView = DynamicFieldViews["field_display_#{viewType}_view"]
      FieldViewClass = dynamicView || FieldDisplayView
    new FieldViewClass(model: @model, field: fieldName, viewType: viewType, label: label, value: value, el: this.$("##{fieldName}View")).render()

  startEditOwner: (event) ->
    @_saveModel(Owner: 'currentuser')
    false

  startEditReady: (event) ->
    updates =
      Ready: !@model.get('Ready')
    updates.Blocked = false if updates.Ready
    @_saveModel updates

  startEditBlocked: ->
    updates =
      Blocked: !@model.get('Blocked')
    updates.Ready = false if updates.Blocked
    @_saveModel updates

  _startEdit: (field) ->
    fieldName = @_getFieldInfo(field)[0]
    @options.edit = fieldName
    @render()
    this.$(".edit ##{fieldName}").focus()

  _saveModel: (updates) ->
    @model.save updates,
      wait: true
      patch: true
      success: =>
        @_switchToViewMode()
      error: =>
        debugger

  _switchToViewMode: ->
    @options.edit = null
    @render()

  _getFieldInfo: (field) ->
    if typeof field is 'object'
      [fieldName, viewType] = ([key, value] for key, value of field)[0]
      if typeof viewType is 'object'
        label = viewType.label
        fieldValue = viewType.value
        viewType = viewType.view
      else
        label = fieldName
    else
      fieldName = field
      viewType = null
      label = field
    [fieldName, viewType, label, fieldValue]

  _getFieldNames: ->
    (@_getFieldInfo(field)[0] for field in @fields)
    