BaseView = require '../view'
template  = require './templates/topbar'

module.exports = class TopbarView extends BaseView

  el: '#topbar'

  template: template

  events:
    'click button[data-target]': 'doNavigate'
    'swipe': 'gotSwiped'

  initialize: (options) ->
    @router = options.router
    @render()

  doNavigate: (e) ->
    page = e.currentTarget.getAttribute 'data-target'

    if page is 'back'
      window.history.back()
      console.log 'navigate back', e
    else
      @router.navigate page, trigger: true
      console.log 'topbar nav to', page

  gotSwiped: (e) ->
    console.log 'got swiped', e

  show: -> @$el.show() if @$el.is ':hidden'

  hide: -> @$el.hide() if @$el.is ':visible'

  getProjectTitle: -> 'Real Project (I Swear)'

  getDetailTitle:  -> 'S1324: Details'

  makeButton: (target, display_text) ->
    """<button class="btn" data-target="#{target}">#{display_text}</button>"""

  getRenderData: ->
    current_page = Backbone.history.location.hash[1...]

    # Default hack.  Need to actually keep track somewhere for more reliability
    current_page = 'home' if current_page.length is 0

    if current_page in ['home', 'board']
      title: @getProjectTitle()
      left_button:  @makeButton 'navigation', 'Navigation'
      right_button: @makeButton 'settings', 'Settings'
    else if current_page is 'navigation'
      onNavigateScreen: true
    else if current_page is 'settings'
      left_button: @makeButton 'back', 'Back'
      title: 'Settings'
    else if current_page is 'login'
      onLoginScreen: true
    else # if current_page in ['detail', 'column']
      title: @getDetailTitle()
      left_button:  @makeButton 'back', 'Back'
      right_button: @makeButton 'settings', 'Settings'

