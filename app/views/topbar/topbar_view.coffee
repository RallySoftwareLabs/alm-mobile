utils = require 'lib/utils'
app = require 'application'
ArtifactCollection = require 'models/artifact_collection'
DefectCollection = require 'models/defect_collection'
TaskCollection = require 'models/task_collection'

BaseView = require 'views/view'
template  = require './templates/topbar'

module.exports = class TopbarView extends BaseView

  ENTER_KEY: 13

  el: '#topbar'

  template: template

  events:
    'click button[data-target]': 'doNavigate'
    'swipe': 'gotSwiped'
    'keydown .search-query': 'searchKeyDown'

  initialize: ({ @settings, @router }) ->

    app.session.on 'loadedSettings', @updateSettingsData, this

    $(window).on 'hashchange', =>
      setTimeout =>
        @render()
        if @_getCurrentPage in ['login']
          @hide()
        else
          @show()
      , 1

  updateSettingsData: =>
    @render()

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
    new ArtifactCollection().fetch
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

  getProjectTitle: -> app.session.project.get('_refObjectName')

  getDetailTitle:  -> 'S1324: Details'

  makeButton: (target, icon, cls = "") ->
    """<a href="##{target}" class="btn navbar-inverse #{cls}"><i class="#{icon}" data-target="#{target}"></i></a>"""

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