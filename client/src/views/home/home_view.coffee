define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class HomeView extends PageView
    listView: null
    tabPane: null
    region: 'main'
    template: hbs['home/templates/home']
    loadingIndicator: true

    listen:
      'projectready mediator': 'updateTitle'

    events:
      'click .nav .btn': 'onPillClick'
      'click .btn-block': 'onRowClick'

    initialize: (options) ->
      super

      @error = false

      @currentTab = options.tab || "userstories"

      unless @listView?
        throw new Error("You must define the list view class in the HomeView subclass")
      unless @createRoute?
        throw new Error("You must define the create route in the HomeView subclass")

      @listenTo @collection, 'sync', @onFetch
      @updateTitle [_.find(@_getTabs(), active: true).value, app.session.getProjectName()].join ' in '

    onFetch: ->
      @stopListening @collection, 'sync', @onFetch
      @view = new @listView
        autoRender: true
        container: @$(".listing")
        collection: @collection

    getTemplateData: ->
      createRoute: @createRoute
      tabs: @_getTabs()

    onPillClick: (event) ->
      url = event.currentTarget.id.replace /\-tab$/, ''
      @publishEvent '!router:route', "/#{url}"

    onRowClick: (event) ->
      url = event.currentTarget.id
      @publishEvent '!router:route', url

    _getTabs: ->
      [
        {
          key: 'userstories'
          value: 'Stories'
          active: @currentTab == 'userstories'
        }
        {
          key: 'tasks'
          value: 'Tasks'
          active: @currentTab == 'tasks'
        }
        {
          key: 'defects'
          value: 'Defects'
          active: @currentTab == 'defects'
        }
      ]