define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  ListPageView = require 'views/listing/list_page_view'

  class SearchView extends ListPageView
    template: hbs['search/templates/search']

    events:
      'click .discussion-reply button': 'onSearch'
      'submit form': 'onSearch'
      'click .list-group-item': 'onRowClick'

    initialize: (options) ->
      super
      @keywords = options.keywords
      @updateTitle "Searching \"#{@keywords}\" in #{app.session.getProjectName()}"

    getTemplateData: ->
      keywords: @keywords

    displayNoSearchResults: ->
      @$('.no-results').show()

    onSearch: (event) ->
      text = @_getInputField().val()
      @trigger 'search', text
      event.preventDefault()

    _getInputField: ->
      @.$('.search-form input')
