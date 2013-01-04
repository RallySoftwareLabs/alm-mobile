require('lib/view_helper')
LoadingMaskView = require './shared/loading_view'

# Base class for all views.
module.exports = Backbone.View.extend
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
