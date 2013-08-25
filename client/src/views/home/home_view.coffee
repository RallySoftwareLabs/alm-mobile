define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'
  ListView = require 'views/home/list_view'

  class HomeView extends PageView
    listView: null
    tabPane: null
    region: 'main'
    template: hbs['home/templates/home']
    loadingIndicator: true

    listen:
      'projectready mediator': 'updateTitle'

    events:
      'click .list-group-item': 'onRowClick'

    initialize: (options) ->
      super

      @error = false

      @currentTab = options.tab || "userstories"

      unless @listType?
        throw new Error("You must define the list type in the HomeView subclass")

      @listenTo @collection, 'sync', @onFetch
      @updateTitle [_.find(@_getTabs(), active: true).value, app.session.getProjectName()].join ' in '

    onFetch: ->
      @stopListening @collection, 'sync', @onFetch
      @view = new ListView
        autoRender: true
        container: @$(".listing")
        collection: @collection
        listType: @listType

    getTemplateData: ->
      createRoute: "new/#{@listType}"
      tabs: @_getTabs()
      iteration: app.session.get('iteration')?.toJSON()

    onRowClick: (event) ->
      url = @listType + '/' + $(event.currentTarget).find('.row')[0].id
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