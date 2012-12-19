View = require 'views/view'
FieldDisplayView = require 'views/field/field_display_view'
FieldEditView = require 'views/field/field_edit_view'

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
      'blur input': 'endEdit'
      'blur textarea': 'endEdit'
    listeners["click ##{key}View.display"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
    listeners

  getRenderData: ->
    edit: @options.edit
    model: @model.toJSON()

  afterRender: ->
    @renderField field for field in @fields

  endEdit: (event) ->
    value = event.target.value
    field = event.target.id
    modelUpdates = {}
    modelUpdates[field] = value
    @_saveModel modelUpdates

  fieldIsEditable: (field) ->
    return false unless field in @_getFieldNames()
    if field in ['FormattedID'] then false else true

  _defineFieldEditFns: (field) ->
    unless @["startEdit#{field}"]?
      @["startEdit#{field}"] = ->
        @_startEdit(field)

  renderField: (field) ->
    [fieldName, viewType] = @_getFieldNameAndViewType(field)
    FieldViewClass = if @options.edit is fieldName then FieldEditView else FieldDisplayView
    new FieldViewClass(model: @model, field: fieldName, viewType: viewType, el: this.$("##{fieldName}View")).render()

  startEditOwner: ->
    @_saveModel(Owner: 'currentuser')

  _startEdit: (field) ->
    fieldName = @_getFieldNameAndViewType(field)[0]
    @options.edit = fieldName
    @render()
    this.$(".edit ##{fieldName}").focus()

  _saveModel: (updates) ->
    @model.save updates,
      wait: true
      patch: true
      success: =>
        @options.edit = null
        @render()
      error: =>
        debugger

  _getFieldNameAndViewType: (field) ->
    if typeof field is 'object'
      [fieldName, viewType] = ([key, value] for key, value of field)[0]
    else
      fieldName = field
      viewType = null
    [fieldName, viewType]

  _getFieldNames: ->
    (@_getFieldNameAndViewType(field)[0] for field in @fields)
    