define [
  'application'
  'lib/utils'
  'views/view'
  'collections/artifacts'
  'collections/defects'
  'collections/tasks'
], (app, utils, View, Artifacts, Defects, Tasks) ->

  class TopbarView extends View

    ENTER_KEY: 13

    el: '#topbar'

    template: JST['topbar/templates/topbar']

    events:
      'click button[data-target]': 'doNavigate'
      'swipe': 'gotSwiped'
      'keydown .search-query': 'searchKeyDown'

    initialize: ({ @settings, @router }) ->
      @subscribe()

      Backbone.on 'loadedSettings', @render, this

      $(window).on 'hashchange', =>
        setTimeout =>
          @render()
          if @_getCurrentPage in ['login']
            @hide()
          else
            @show()
        , 1

    subscribe: ->
      Backbone.on("updatetitle", @updateTitle, this)

    doNavigate: (e) ->
      page = e.currentTarget.getAttribute 'data-target'

      if page is 'back'
        window.history.back()
      else
        @router.navigate page, trigger: true
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
            @router.navigate utils.getDetailHash(firstResult), trigger: true
          else
            @_noSearchResults()

    gotSwiped: (e) ->
      console.log 'got swiped', e

    show: -> @$el.show() if @$el.is ':hidden'

    hide: -> @$el.hide() if @$el.is ':visible'

    makeButton: (target, icon, cls = "") ->
      """<a href="##{target}" class="btn navbar-inverse #{cls}"><i class="#{icon}" data-target="#{target}"></i></a>"""

    getRenderData: ->
      current_page = @_getCurrentPage()

      data = {title: @title}

      if current_page in ['home', 'board']
        data.left_button =  @makeButton 'navigation', 'icon-reorder', 'cyan'
        data.right_button = @makeButton 'settings', 'icon-cog'
      else if current_page is 'navigation'
        data.onNavigateScreen = true
      else if current_page is 'settings'
        data.left_button = @makeButton 'back', 'icon-arrow-left'
      else if current_page is 'login'
        data.onLoginScreen = true
      else # if current_page in ['detail', 'column']
        data.left_button =  @makeButton 'back', 'icon-arrow-left'
        data.right_button = @makeButton 'settings', 'icon-cog'

      data

    updateTitle: (title) ->
      @title = title
      @render()

    _getCurrentPage: ->
      (key for key, value of @router.currentPage)[0]

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