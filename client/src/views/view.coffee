define [
  'lib/view_helper'
  'views/shared/loading_view'
], (ViewHelper, LoadingMaskView) ->

# Base class for all views.
  Backbone.View.extend
    initialize: (options) ->
      @render = _.bind(@render, @)
      @renderLoadingMask()

    renderLoadingMask: ->
      mask = new LoadingMaskView()
      mask.setElement(@el)
      mask.render()

    template: ->
    getRenderData: ->

    render: ->
      @$el.html(@template(@getRenderData()))
      @afterRender()
      @

    afterRender: ->
