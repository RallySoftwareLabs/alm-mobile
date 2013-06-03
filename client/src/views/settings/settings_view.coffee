define [
  'hbsTemplate'
  'application'
  'views/view'
], (hbs, app, View) ->

  class SettingsView extends View

    template: hbs['settings/templates/settings']

    initialize: ->
      super
      Backbone.on 'loadedSettings', @render, this
      Backbone.trigger "updatetitle", "Settings"

    events:
      'click button.logout': 'triggerLogout'
      'change select.project': 'updateSelectedProject'

    getRenderData: ->
      projects: app.session.projects?.models
      currentProject: app.session.project

    triggerLogout: ->
      app.session.logout()
      app.router.navigate 'login', trigger: true

    updateSelectedProject: ->
      app.session.setProject _find(
        app.session.projects,
        (proj) -> proj.get('_ref') is @$('option:selected').val(),
        this
      )
      @render()
