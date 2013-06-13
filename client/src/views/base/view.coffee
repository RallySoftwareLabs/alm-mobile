define ->
  _ = require 'underscore'
  Chaplin = require 'chaplin'
  Spinner = require 'spin'
  ViewHelper = require 'views/base/view_helper'

  __initLoadingIndicator__ = ->
    model = @model || @collection
    return unless model && @loadingIndicator

    syncEvent = if _.isFunction(model.isSyncing) then 'syncStateChange' else 'sync'
    @listenTo model, syncEvent, _.bind(__toggleLoadingIndicator__, this, false)
    __toggleLoadingIndicator__.call this, true

  __toggleLoadingIndicator__ = (show = false) ->
    model = @model || @collection

    visible = if _.isFunction(model.isSyncing) then model.isSyncing() else show

    if visible
      @$el.append(new Spinner().spin().el)
    else
      @$('.spinner').remove()

  # Base class for all views.
  class View extends Chaplin.View
    keyCodes:
      ENTER_KEY: 13
      ESCAPE_KEY: 27

    getTemplateFunction: -> @template

    attach: ->
      super
      __initLoadingIndicator__.apply this unless @showLoadingIndicator == false
      @afterRender()
      this

    afterRender: ->

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    # listens to an event on the object and refires is as its own
    bubbleEvent: (obj, event, mappedAs = event) ->
      @listenTo obj, event, (args...) => @trigger.apply this, [mappedAs].concat(args) 