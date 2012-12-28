require('lib/view_helper')

# Base class for all views.
module.exports = Backbone.View.extend
  initialize: (options) ->
    @render = _.bind(@render, @)
    @renderLoadingMask()

  renderLoadingMask: ->
  template: ->
  getRenderData: ->

  render: ->
    @$el.html(@template(@getRenderData()))
    @afterRender()
    @

  afterRender: ->
