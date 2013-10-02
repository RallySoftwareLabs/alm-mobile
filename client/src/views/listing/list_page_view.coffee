define ->
  PageView = require 'views/base/page_view'
  ListView = require 'views/listing/list_view'

  class ListPageView extends PageView
    region: 'main'
    loadingIndicator: true

    initialize: (options) ->
      super
      @listenToOnce @collection, 'sync', @onFetch

    onFetch: ->
      @view = new ListView
        autoRender: true
        container: @$(".listing")
        collection: @collection

    onRowClick: (event) ->
      url = $(event.currentTarget).find('.row')[0].dataset.url
      @trigger 'itemclick', url
      event.preventDefault()

