define ->
  Chaplin = require 'chaplin'
  ViewHelper = require 'lib/view_helper'
  LoadingMaskView = require 'views/shared/loading_view'

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

    attach: ->
      super
      @afterRender()
      this

    afterRender: ->

    updateTitle: (title) ->
      @publishEvent "updatetitle", title

    # listens to an event on the object and refires is as its own
    bubbleEvent: (obj, event, mappedAs = event) ->
      @listenTo obj, event, (args...) => @trigger.apply this, [mappedAs].concat(args) 