require('lib/view_helper')

# Base class for all views.
module.exports = Backbone.View.extend
  initialize: ->
    @render = _.bind(@render, @)

  template: ->
  getRenderData: ->

  render: ->
    @$el.html(@template(@getRenderData()))
    @afterRender()
    @

  afterRender: ->
