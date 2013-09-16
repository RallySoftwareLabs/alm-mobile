define ->
  app = require 'application'
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  ViewMode =
    DISPLAY: 'display'
    EDIT: 'edit'

  class FieldView extends View
    initialize: (options) ->
      @viewType = options.viewType || 'string'
      @inputType = options.inputType || 'text'
      @setEditMode = if @setEditMode? then @setEditMode else true
      @viewMode = if (options.newArtifact? and options.newArtifact and @setEditMode) then ViewMode.EDIT else ViewMode.DISPLAY
      @_setDisplayTemplate()
      @detailView = options.detailView
      @listenTo @detailView, 'fieldSave', @_otherFieldSave

      if options.editable
        @delegate "click", @startEdit

      super options

    getTemplateData: ->
      model: @model.toJSON()
      field: @options.field
      fieldLabel: @options.label
      fieldValue: @getFieldValue()
      inputType: @inputType
      allowedValues: @getAllowedValues()
      currentHash: Backbone.history.getHash()
      icon: @options.icon

    afterRender: ->
      if @viewMode is ViewMode.DISPLAY
        @$el.addClass('display')
        @$el.removeClass('edit')
      else
        @$el.removeClass('display')
        @$el.addClass('edit')

    _setDisplayTemplate: ->
      view = @viewType
      view = 'titled_well_dropdown' if @viewMode is ViewMode.EDIT and @viewType is 'titled_well' and @model.allowedValues?[@options.field]
      @template = hbs["field/templates/#{@viewMode}/#{view}_view"]

      unless @template
        @viewMode = ViewMode.DISPLAY
        @_setDisplayTemplate()

    startEdit: ->
      @_switchToEditMode()
      # @render()
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

    getFieldValue: ->
      @options.value || @model.get(@options.field)

    getAllowedValues: ->
      if app.session.get('boardField') == @options.field
        boardColumns = app.session.getBoardColumns()
        return boardColumns if _.contains boardColumns, @getFieldValue()
        
      av = @model.getAllowedValues?(@options.field)
      av && _.pluck(av, 'StringValue')

    _saveLocal: (updates, opts) ->
      @model.set(updates)
      @render()

    _saveRemote: (updates, opts) ->
      @model.save updates,
        fetch: ['ObjectID'].concat(@detailView.getFieldNames()).join ','
        wait: true
        patch: true
        success: (model, resp, options) =>
          opts?.success?(model, resp, options)
          @_switchToViewMode()
          @trigger('save', @options.field, model)
        error: (model, xhr, options) =>
          opts?.error?(model, xhr, options)

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
      @render()
