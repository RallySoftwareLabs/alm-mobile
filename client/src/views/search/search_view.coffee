define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  ListPageView = require 'views/listing/list_page_view'

  class SearchView extends ListPageView
    template: hbs['search/templates/search']

    events:
      'submit form': 'onSearch'
      'keydown .search-form input': 'searchKeyDown'

    initialize: (options = {}) ->
      super
      @showLoadingIndicator = options.showLoadingIndicator
      @keywords = options.keywords
      @updateTitle "Searching \"#{@keywords}\" in #{app.session.getProjectName()}"

    getTemplateData: ->
      keywords: @keywords

    afterRender: ->
      super
      @_getInputField().focus()

    displayNoSearchResults: ->
      @$('.no-results').show()

    searchKeyDown: (event) ->
      @onSearch(event) if event.which == @keyCodes.ENTER_KEY

    onSearch: (event) ->
      text = @_getInputField().val()
      @trigger 'search', text
      event.preventDefault()

    _getInputField: ->
      @.$('.search-form input')
