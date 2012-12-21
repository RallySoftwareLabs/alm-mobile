BaseView = require '../view'
template  = require './templates/settings'
ProjectCollection = require 'models/project_collection'

module.exports = class SettingsView extends BaseView

  el: '#content'

  template: template

  initialize: ->
    @projects = new ProjectCollection
    @projects.fetch
      data:
        fetch: ['_refObjectName', '_ref'].join ','
      success: (collection, response, options) =>
        @render()
        debugger
      failure: (collection, xhr, options) =>
        @error = true

  getRenderData: ->
    projects: @projects.models
