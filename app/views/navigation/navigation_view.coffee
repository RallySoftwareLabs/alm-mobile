template  = require './templates/navigation'

module.exports = Backbone.View.extend

  initialize: ->
    console.log 'initing nav view'

  el: '#content'

  template: template

  render: ->
    @$el.html @template @getRenderData()
    @
