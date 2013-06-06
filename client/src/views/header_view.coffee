define [
  'chaplin'
  'views/base/view'
  'hbsTemplate'
], (Chaplin, View, hbs) ->

  class HeaderView extends View
    autoRender: true
    region: 'header'
    template: hbs['templates/header']

    ENTER_KEY: 13

    template: hbs['topbar/templates/topbar']

    listen:
      'updatetitle mediator': 'updateTitle'
      'loadedSettings mediator': 'render'
      'dispatcher:dispatch mediator': 'render'

    events:
      'click div[data-target]': 'doNavigate'
      'swipe': 'gotSwiped'
      'keydown .search-query': 'searchKeyDown'

    initialize: ->
      super
      @subscribeEvent 'navigation:show', @onNavigationShow
      @subscribeEvent 'navigation:hide', @onNavigationHide

    doNavigate: (e) ->
      page = e.currentTarget.getAttribute 'data-target'

      if page is 'back'
        window.history.back()
      else if page is 'navigation'
        @publishEvent 'navigation:show'
      else
        @publishEvent '!router:route', page
      e.preventDefault()

    searchKeyDown: (event) ->
      switch event.which
        when @ENTER_KEY
          event.preventDefault()
          @doSearch event.target.value

    doSearch: (keyword) ->
      $('.search-no-results').remove()
      new Artifacts().fetch
        data:
          fetch: "ObjectID,Name"
          search: keyword
        success: (collection, response, options) =>
          if collection.length > 0
            firstResult = collection.first()
            @publishEvent '!router:route', utils.getDetailHash(firstResult)
          else
            @_noSearchResults()

    gotSwiped: (e) ->
      console.log 'got swiped', e

    show: -> @$el.show() if @$el.is ':hidden'

    hide: -> @$el.hide() if @$el.is ':visible'

    makeButton: (target, icon, cls = "") ->
      """<div class="btn navbar-inverse #{cls}" data-target="#{target}"><i class="#{icon}"></i></div>"""

    getTemplateData: ->
      current_page = @_getCurrentPage()

      data = {title: @title}

      if @onNavigateScreen
        data.onNavigateScreen = true
      else if current_page in ['/userstories', '/defects', '/tasks']
        data.left_button =  @makeButton 'navigation', 'icon-reorder', 'cyan'
        data.right_button = @makeButton 'settings', 'icon-cog'
      else if current_page is '/settings'
        data.left_button = @makeButton 'back', 'icon-arrow-left'
      else # if current_page in ['detail', 'column']
        data.left_button =  @makeButton 'back', 'icon-arrow-left'
        data.right_button = @makeButton 'settings', 'icon-cog'

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

    _noSearchResults: ->
      alert = $('body').append([
        '<div class="search-no-results alert alert-error">',
        '<button type="button" class="close" data-dismiss="alert">&times;</button>',
        'No results matched your search.</div>'
      ].join '')
      noResults = $('.search-no-results')
      @_center(noResults)
      setTimeout(->
        noResults = $('.search-no-results')
        noResults.fadeOut(400, -> noResults.remove())
      , 1500)

    _center: (el) ->
      container = $(window)
      boundingRec = $('.search-query')[0].getBoundingClientRect()
      el.css('top': "#{boundingRec.top + boundingRec.height}px", 'left': "#{boundingRec.left}px")