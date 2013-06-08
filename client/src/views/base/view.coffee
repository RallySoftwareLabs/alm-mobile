define [
  'chaplin'
  'lib/view_helper'
  'views/shared/loading_view'
], (Chaplin, ViewHelper, LoadingMaskView) ->

# Base class for all views.
  class View extends Chaplin.View
    keyCodes:
      ENTER_KEY: 13
      ESCAPE_KEY: 27

    # initialize: ->
      # @render = _.bind(@render, @)
      # @renderLoadingMask()

    # renderLoadingMask: ->
    #   mask = new LoadingMaskView()
    #   mask.setElement(@el)
    #   mask.render()

    getTemplateFunction: -> @template
    getTemplateData: ->

    attach: ->
      super
      @afterRender()
      @

    afterRender: ->

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    # listens to an event on the object and refires is as its own
    bubbleEvent: (obj, event, mappedAs = event) ->
      @listenTo obj, event, (args...) => @trigger.apply this, [mappedAs].concat(args) 