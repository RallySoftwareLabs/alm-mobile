View = require 'views/view'

ViewMode =
  DISPLAY: 'display'
  EDIT: 'edit'

ENTER_KEY = 13

module.exports = class FieldView extends View
  initialize: (options) ->
    @viewType = options.viewType || 'string'
    @viewMode = ViewMode.DISPLAY
    @_setDisplayTemplate()
    options.detailView.on('fieldSave', @_otherFieldSave, @)

  events: ->
    return {
      'blur input': 'onBlur'
      'blur textarea': 'onBlur'
      'keydown input': 'onKeyDown'
    }

  getRenderData: ->
    model: @model.toJSON()
    field: @options.field
    fieldLabel: @options.label
    fieldValue: @options.value || @model.get(@options.field)
    currentHash: Backbone.history.getHash()
  
  afterRender: ->
    if @viewMode is ViewMode.DISPLAY
      @.$el.addClass('display')
      @.$el.removeClass('edit')
    else
      @.$el.removeClass('display')
      @.$el.addClass('edit')

  _setDisplayTemplate: () ->
    @template = require "views/field/templates/#{@viewMode}/#{@viewType}_view"

  startEditOwner: (event) ->
    @saveModel(Owner: 'currentuser')
    false

  startEdit: ->
    @_switchToEditMode()
    @render()
    this.$("input").focus()

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

  onBlur: (event) ->
    @endEdit event

  onKeyDown: (event) ->
    @endEdit(event) if event.which is ENTER_KEY

  saveModel: (updates, opts) ->
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
    @viewMode = ViewMode.EDIT
    @_setDisplayTemplate()
    @render()

  _switchToViewMode: ->
    @viewMode = ViewMode.DISPLAY
    @_setDisplayTemplate()
    @render()

  _otherFieldSave: (field, model) ->
    @model = model
