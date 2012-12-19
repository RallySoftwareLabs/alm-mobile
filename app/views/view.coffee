require('lib/view_helper')

# Base class for all views.
module.exports = Backbone.View.extend
  initialize: (options) ->
    # Backbone.View.prototype.initialize.call(this, [options])
    @render = _.bind(@render, @)

  template: ->
  getRenderData: ->

  render: ->
    @$el.html(@template(@getRenderData()))
    @afterRender()
    @

  afterRender: ->
