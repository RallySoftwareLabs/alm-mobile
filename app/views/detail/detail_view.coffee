View = require 'views/view'
FieldDisplayView = require 'views/field/field_display_view'
FieldEditView = require 'views/field/field_edit_view'

module.exports = View.extend
  initialize: (options) ->
    View.prototype.initialize.call(this, [options])
    @_defineFieldEditFns field for field in @fields
    @model = new @modelType(ObjectID: options.oid)
    @model.fetch({
      data:
        fetch: ['ObjectID'].concat(@fields).join ','
      success: (model, response, opts) =>
        @delegateEvents()
        @render() if options.autoRender
    })

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