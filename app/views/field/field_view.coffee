View = require 'views/view'

ViewMode =
  DISPLAY: 'display'
  EDIT: 'edit'

module.exports = View.extend
  initialize: (options) ->
    @viewType = options.viewType || 'string'
    @viewMode = ViewMode.DISPLAY
    @template = @_getDisplayTemplate(options.field)
    options.detailView.on('fieldSave', @_otherFieldSave, @)

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

  _getDisplayTemplate: (field) ->
    return require "views/field/templates/#{@viewMode}/#{@viewType}_view"

  startEditOwner: (event) ->
    @saveModel(Owner: 'currentuser')
    false

  startEdit: ->
    @_switchToEditMode()
    @render()
    this.$(".edit ##{@options.field}").focus()

  saveModel: (updates) ->
    @model.save updates,
      wait: true
      patch: true
      success: (model, resp, options) =>
        @_switchToViewMode()
        @trigger('save', @options.field, model)
      error: =>
        debugger

  _switchToEditMode: ->
    @viewMode = ViewMode.EDIT
    @render()

  _switchToViewMode: ->
    @viewMode = ViewMode.DISPLAY
    @render()

  _otherFieldSave: (field, model) ->
    @model = model
