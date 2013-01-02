BaseView = require '../view'
template  = require './templates/settings'
ProjectCollection = require 'models/project_collection'

module.exports = class SettingsView extends BaseView

  template: template

  events:
    'click button.logout': 'triggerLogout'
    'change select.project': 'updateSelectedProject'

  initialize: ({ @session, @router }) ->
    @projects = new ProjectCollection
    @projects.fetch
      success: (collection) =>
        @currentProjectTitle = collection.first().get '_refObjectName'
        @currentProjectRef   = collection.first().get '_ref'
        @trigger 'loadedSettings'
    @projects.on 'reset', @render, @

  getRenderData: ->
    projects: @projects.models

  getProjectTitle: -> @currentProjectTitle

  getProjectRef:   -> @currentProjectRef

  triggerLogout: ->
    @session.logout()
    @router.navigate 'login', trigger: true

  updateSelectedProject: ->
    @trigger 'loadedSettings'
    @currentProjectTitle = @$('option:selected').text()
    @currentProjectRef   = @$('option:selected').val()
