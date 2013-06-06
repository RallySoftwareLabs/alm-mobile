define [
  'chaplin'
  'lib/view_helper'
  'views/shared/loading_view'
], (Chaplin, ViewHelper, LoadingMaskView) ->

# Base class for all views.
  class View extends Chaplin.View
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
