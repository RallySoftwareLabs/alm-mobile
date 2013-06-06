define [
  'underscore'
  'hbsTemplate'
  'application'
  'views/base/page_view'
], (_, hbs, app, PageView) ->

  class SettingsView extends PageView
    autoRender: true
    template: hbs['settings/templates/settings']

    listen:
      'loadedSettings mediator': 'render'

    events:
      'click button.logout': 'triggerLogout'
      'change select.project': 'updateSelectedProject'

    initialize: ->
      super
      @publishEvent "updatetitle", "Settings"

    getTemplateData: ->
      projects: app.session.projects?.models
      currentProject: app.session.project.get('_ref')

    triggerLogout: ->
      app.session.logout()
      @publishEvent '!router:routeByName', 'auth#login'

    updateSelectedProject: ->
      app.session.setProject _.find(
        app.session.projects.models,
        (proj) -> proj.get('_ref') is @$('option:selected').val(),
        this
      )
      @render()
