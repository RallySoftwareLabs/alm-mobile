define ->
  Chaplin = require 'chaplin'
  View = require 'views/base/view'
  Spinner = require 'spin'

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

    attach: View::attach

    afterRender: View::afterRender
