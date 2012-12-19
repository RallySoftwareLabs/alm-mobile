template  = require './templates/topbar'
app = require '../../application'

module.exports = Backbone.View.extend

  el: '#topbar'

  events:
    'click a[data-target="back"]': 'navigateBack'
    'click a[data-target="settings"]': 'openSettings'

  initialize: (options) ->
    # console.log 'initing topbar view'
    @render()

  navigateBack: ->
    console.log 'navigateBack'

  openSettings: ->
    console.log 'openSettings'

  render: ->
    @$el.html @template @getRenderData()
    @

  getRenderData: ->
    title: 'Home'
    left_button: """<a href="#" data-target="back">Back</a>"""
    right_button: """<a href="#" data-target="settings">Settings</a>"""

  template: template
