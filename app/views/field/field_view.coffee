View = require 'views/view'

ViewMode =
  DISPLAY: 'display'
  EDIT: 'edit'

module.exports = class FieldView extends View
  initialize: (options) ->
    @viewType = options.viewType || 'string'
    @viewMode = if (options.newArtifact? and options.newArtifact) then ViewMode.EDIT else ViewMode.DISPLAY
    @_setDisplayTemplate()
    options.detailView.on('fieldSave', @_otherFieldSave, @)

  events: ->
    return {}

  getRenderData: ->
    model: @model.toJSON()
    field: @options.field
    fieldLabel: @options.label
    fieldValue: @options.value || @model.get(@options.field)
    allowedValues: @options.allowedValues
    currentHash: Backbone.history.getHash()
    icon: @options.icon

  afterRender: ->
    if @viewMode is ViewMode.DISPLAY
      @.$el.addClass('display')
      @.$el.removeClass('edit')
    else
      @.$el.removeClass('display')
      @.$el.addClass('edit')

  _setDisplayTemplate: ->
    try
      view = @viewType
      view = 'titled_well_dropdown' if @viewMode is ViewMode.EDIT and @viewType is 'titled_well' and @options.allowedValues?
      @template = require "views/field/templates/#{@viewMode}/#{view}_view"
    catch e
      @viewMode = ViewMode.DISPLAY
      @_setDisplayTemplate()

  startEdit: ->
    @_switchToEditMode()
    @render()
    this.$(".editor").focus()

  endEdit: (event) ->
    value = event.target.value
    field = event.target.id
    event.preventDefault()
    if @model.get(field) isnt value
      modelUpdates = {}
      modelUpdates[field] = value
      @saveModel modelUpdates
    else
      @_switchToViewMode()

  saveModel: (updates, opts) ->
    if @options.newArtifact
      @_saveLocal(updates, opts)
    else
      @_saveRemote(updates, opts)

  _saveLocal: (updates, opts) ->
    @model.set(updates)
    @render()

  _saveRemote: (updates, opts) ->
    @model.save updates,
      wait: true
      patch: true
      success: (model, resp, options) =>
        opts?.success?(model, resp, options)
        @_switchToViewMode()
        @trigger('save', @options.field, model)
      error: =>
        opts?.error?(model, resp, options)
        debugger


  _switchToEditMode: ->
    if @viewMode isnt ViewMode.EDIT
      @viewMode = ViewMode.EDIT
      @_setDisplayTemplate()

    @render()

  _switchToViewMode: ->
    if @viewMode isnt ViewMode.DISPLAY
      @viewMode = ViewMode.DISPLAY
      @_setDisplayTemplate()

    @render()

  _otherFieldSave: (field, model) ->
    @model = model
