template  = require './templates/topbar'

module.exports = Backbone.View.extend

  el: '#topbar'

  events:
    'click a[data-target="back"]'    : 'navigateBack'
    'click a[data-target="navigate"]': 'openNavigation'
    'click a[data-target="settings"]': 'openSettings'
    'swipe': 'gotSwiped'

  initialize: (options) ->
    @router = options.router
    @render()

  navigateBack: ->
    console.log 'navigate back'

  openNavigation: ->
    console.log 'open navigation view'

  openSettings: ->
    @router.navigate 'settings', trigger: true
    console.log 'open settings view'

  gotSwiped: (e) ->
    console.log 'got swiped', e

  show: -> @$el.show() if @$el.is ':hidden'

  hide: -> @$el.hide() if @$el.is ':visible'

  render: ->
    @$el.html @template @getRenderData()
    @

  getProjectTitle: -> 'Real Project'

  getDetailTitle:  -> 'S1324: Details'

  makeButton: (target, display_text) -> """<a href="#" data-target="#{target}">#{display_text}</a>"""

  getRenderData: ->
    current_page = Backbone.history.location.hash[1...]

    if current_page in ['home', 'board']
      title: @getProjectTitle()
      left_button:  @makeButton 'navigate', 'Navigate'
      right_button: @makeButton 'settings', 'Settings'
    else if current_page is 'navigation'
      onNavigateScreen: true
    else if current_page is 'settings'
      left_button: @mateButton 'back', 'Back'
      title: 'Settings'
    else if current_page is 'login'
      onLoginScreen: true
    else # if current_page in ['detail', 'column']
      title: @getDetailTitle()
      left_button:  @makeButton 'back', 'Back'
      right_button: @makeButton 'settings', 'Settings'

  template: template
