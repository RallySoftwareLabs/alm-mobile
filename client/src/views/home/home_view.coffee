define ->
  hbs = require 'hbsTemplate'
  app = require 'application'
  ListPageView = require 'views/listing/list_page_view'

  class HomeView extends ListPageView
    template: hbs['home/templates/home']

    events:
      'click .list-group-item': 'onRowClick'

    initialize: (options) ->
      super

      @error = false

      @currentTab = options.tab || "userstories"

      unless @listType?
        throw new Error("You must define the list type in the HomeView subclass")

      @updateTitle [_.find(@_getTabs(), active: true).value, app.session.getProjectName()].join ' in '

    getTemplateData: ->
      createRoute: "new/#{@listType}"
      tabs: @_getTabs()
      iteration: app.session.get('iteration')?.toJSON()

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