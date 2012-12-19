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
      'blur input': 'saveModel'
    listeners["click ##{key}View.display"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
    listeners

  getRenderData: ->
    edit: @options.edit
    model: @model.toJSON()

  afterRender: ->
    @renderField field for field in @fields

  saveModel: (event) ->
    value = event.target.value
    field = event.target.id
    modelUpdates = {}
    modelUpdates[field] = value
    @model.save modelUpdates,
      wait: true
      patch: true
      success: =>
        @options.edit = null
        @render()
      error: =>
        debugger

  fieldIsEditable: (field) ->
    return false unless field in @_getFieldNames()
    if field in ['FormattedID'] then false else true

  _defineFieldEditFns: (field) ->
    @["startEdit#{field}"] = ->
      @_startEdit(field)

  renderField: (field) ->
    [fieldName, viewType] = @_getFieldNameAndViewType(field)
    FieldViewClass = if @options.edit is fieldName then FieldEditView else FieldDisplayView
    new FieldViewClass(model: @model, field: fieldName, viewType: viewType, el: this.$("##{fieldName}View")).render()

  _startEdit: (field) ->
    fieldName = @_getFieldNameAndViewType(field)[0]
    @options.edit = fieldName
    @render()
    this.$(".controls ##{fieldName}").focus()

  _getFieldNameAndViewType: (field) ->
    if typeof field is 'object'
      [fieldName, viewType] = ([key, value] for key, value of field)[0]
    else
      fieldName = field
      viewType = null
    [fieldName, viewType]

  _getFieldNames: ->
    (@_getFieldNameAndViewType(field)[0] for field in @fields)
    