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

    $(window).on 'hashchange', =>
      setTimeout =>
        @render()
        if @_getCurrentPage in ['login']
          @hide()
        else
          @show()
      , 1

  doNavigate: (e) ->
    page = e.currentTarget.getAttribute 'data-target'

    if page is 'back'
      window.history.back()
    else
      @router.navigate page, trigger: true

  gotSwiped: (e) ->
    console.log 'got swiped', e

  show: -> @$el.show() if @$el.is ':hidden'

  hide: -> @$el.hide() if @$el.is ':visible'

  getProjectTitle: -> 'Real Project (I Swear)'

  getDetailTitle:  -> 'S1324: Details'

  makeButton: (target, icon, cls = "") ->
    """<a class="btn #{cls}"><i class="#{icon}" data-target="#{target}"></i></a>"""

  getRenderData: ->
    current_page = @_getCurrentPage()

    # Default hack.  Need to actually keep track somewhere for more reliability
    # current_page = 'home' if current_page.length is 0

    if current_page in ['home', 'board']
      title: @getProjectTitle()
      left_button:  @makeButton 'navigation', 'icon-reorder', 'cyan'
      right_button: @makeButton 'settings', 'icon-cog'
    else if current_page is 'navigation'
      onNavigateScreen: true
    else if current_page is 'settings'
      left_button: @makeButton 'back', 'icon-arrow-left'
      title: 'Settings'
    else if current_page is 'login'
      onLoginScreen: true
    else # if current_page in ['detail', 'column']
      title: @getDetailTitle()
      left_button:  @makeButton 'back', 'icon-arrow-left'
      right_button: @makeButton 'settings', 'icon-cog'

  _getCurrentPage: ->
    (key for key, value of @router.currentPage)[0]
