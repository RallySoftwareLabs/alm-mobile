BaseView = require '../view'
template  = require './templates/settings'
ProjectCollection = require 'models/project_collection'

module.exports = class SettingsView extends BaseView

  template: template

  events:
    'click button.logout': 'triggerLogout'

  initialize: ({ @session, @router }) ->
    @projects = new ProjectCollection
    @projects.on 'reset', @render, @

  getRenderData: ->
    projects: @projects.models

  triggerLogout: ->
    @session.logout()
    @router.navigate 'login', trigger: true