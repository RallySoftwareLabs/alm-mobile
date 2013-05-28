define [
  'application'
  'views/view'
], (app, View) ->

  class SettingsView extends View

    template: JST['settings/templates/settings']

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
      @session.logout()
      @router.navigate 'login', trigger: true

    updateSelectedProject: ->
      app.session.setProject _find(
        app.session.projects,
        (proj) -> proj.get('_ref') is @$('option:selected').val(),
        this
      )
      @render()
