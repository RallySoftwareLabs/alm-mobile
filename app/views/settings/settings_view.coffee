template  = require './templates/settings'

module.exports = Backbone.View.extend

  el: '#content'

  template: template

  initialize: ->
    @render()

  getRenderData: ->
    projects: [
      { name: 'Project 1' }
      { name: 'Project 2' }
      { name: 'Project 3' }
    ]

  render: ->
    @$el.html @template @getRenderData()
    @
