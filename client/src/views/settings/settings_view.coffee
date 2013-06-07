define ->
  _ = require 'underscore'
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class SettingsView extends PageView
    autoRender: true
    template: hbs['settings/templates/settings']

    events:
      'click button.logout': 'triggerLogout'
      'change select.project': 'updateSelectedProject'

    initialize: (options) ->
      @mode = options.mode
      super
      @updateTitle "Settings"
      @delegate 'click', '.self', => @toggleMode 'self'
      @delegate 'click', '.team', => @toggleMode 'team'

    getTemplateData: ->
      projects: app.session.projects?.models
      currentProject: app.session.project.get('_ref')
      isTeam: @mode == 'team'
      isSelf: @mode == 'self'

    triggerLogout: ->
      app.session.logout()
      @publishEvent '!router:routeByName', 'auth#login'

    toggleMode: (mode) ->
      @mode = mode
      @trigger 'toggleMode', mode
      @render()

    updateSelectedProject: ->
      app.session.setProject _.find(
        app.session.projects.models,
        (proj) -> proj.get('_ref') is @$('option:selected').val(),
        this
      )
      @render()
