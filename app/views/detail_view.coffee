View = require 'views/view'
FieldDisplayView = require 'views/field_display_view'
FieldEditView = require 'views/field_edit_view'

module.exports = View.extend
  initialize: ->
    @_defineFieldEditFns field for field in @fields

  events: ->
    listeners = 
      'blur .controls input': 'saveModel'
    listeners["click .controls.display.#{key}"] = "startEdit#{key}" for key of @model.attributes when @fieldIsEditable(key)
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
    return false unless field in @fields
    if field in ['FormattedID'] then false else true

  _defineFieldEditFns: (field) ->
    @["startEdit#{field}"] = ->
      @_startEdit(field)

  renderField: (field) ->
    FieldViewClass = if @options.edit is field then FieldEditView else FieldDisplayView
    new FieldViewClass(model: @model, field: field, el: this.$("##{field}View")).render()

  _startEdit: (field) ->
    @options.edit = field
    @render()
    this.$(".controls ##{field}").focus()