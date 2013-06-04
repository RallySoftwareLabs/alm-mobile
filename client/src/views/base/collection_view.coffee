define [
  'chaplin'
  'lib/view_helper'
  'views/base/view'
  'views/shared/loading_view'
], (Chaplin, ViewHelper, View, LoadingMaskView) ->

# Base class for collection views.
  class CollectionView extends Chaplin.CollectionView
    # initialize: ->
      # @render = _.bind(@render, @)
      # @renderLoadingMask()

    # renderLoadingMask: ->
    #   mask = new LoadingMaskView()
    #   mask.setElement(@el)
    #   mask.render()

    getTemplateFunction: View::getTemplateFunction

    render: ->
      super
      @afterRender()
      @

    afterRender: ->
