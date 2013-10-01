define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'
  ListView = require 'views/home/list_view'

  class SearchView extends PageView
    listView: null
    tabPane: null
    region: 'main'
    template: hbs['search/templates/search']
    loadingIndicator: true

    listen:
      'projectready mediator': 'updateTitle'

    events:
      'click .discussion-reply button': 'onSearch'
      'submit form': 'onSearch'
      'click .list-group-item': 'onRowClick'

    initialize: (options) ->
      super
      @keywords = options.keywords

      @listenTo @collection, 'sync', @onFetch
      @updateTitle "Searching \"#{@keywords}\""

    getTemplateData: ->
      data = super
      data.keywords = @keywords

      data

    onFetch: ->
      @stopListening @collection, 'sync', @onFetch
      @view = new ListView
        autoRender: true
        container: @$(".listing")
        collection: @collection

    displayNoSearchResults: ->
      @$('.no-results').show()

    onSearch: (event) ->
      text = @_getInputField().val()
      @trigger 'search', text
      event.preventDefault()

    onRowClick: (event) ->
      url = $(event.currentTarget).find('.row')[0].dataset.url
      @publishEvent '!router:route', url

    _getInputField: ->
      @.$('.search-form input')
