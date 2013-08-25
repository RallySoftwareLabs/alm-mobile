define ->
  Chaplin = require 'chaplin'
  hbs = require 'hbsTemplate'
  View = require 'views/base/view'

  class HeaderView extends View
    autoRender: true
    region: 'header'
    template: hbs['templates/header']

    listen:
      'updatetitle mediator': 'updateTitle'
      'projectready mediator': 'render'
      'dispatcher:dispatch mediator': 'render'
      'navigation:show mediator': 'onNavigationShow'
      'navigation:hide mediator': 'onNavigationHide'

    events:
      'click a[data-target]': 'doNavigate'
      'swipe': 'gotSwiped'

    doNavigate: (e) ->
      page = e.currentTarget.getAttribute 'data-target'

      if page is 'back'
        window.history.back()
      else if page is 'navigation'
        @publishEvent 'navigation:show'
      else
        @publishEvent '!router:route', page
      e.preventDefault()


    gotSwiped: (e) ->
      console.log 'got swiped', e

    show: -> @$el.show() if @$el.is ':hidden'

    hide: -> @$el.hide() if @$el.is ':visible'

    makeButton: (target, icon, cls = "") ->
      """<a href="#" class="#{cls}" data-target="#{target}"><i class="icon-#{icon}"></i></a>"""

    getTemplateData: ->
      current_page = @_getCurrentPage()

      data =
        title: @title
        onNavigateScreen: @onNavigateScreen

      if current_page in ['/userstories', '/defects', '/tasks', '/board', '/recentActivity']
        data.left_button =  @makeButton 'navigation', 'reorder', 'left'
        data.right_button = @makeButton 'settings', 'cog', 'right'
      else if current_page is '/settings'
        data.left_button = @makeButton 'back', 'arrow-left', 'left'
      else # if current_page in ['detail', 'column']
        data.left_button =  @makeButton 'back', 'arrow-left', 'left'
        data.right_button = @makeButton 'settings', 'cog', 'right'

      data

    updateTitle: (title) ->
      @title = title
      @render()

    onNavigationShow: ->
      @onNavigateScreen = true
      @render()

    onNavigationHide: ->
      @onNavigateScreen = false
      @render()

    _getCurrentPage: ->
      window.location.pathname
