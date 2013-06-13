define ->
  _ = require 'underscore'
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class BoardSettingsView extends PageView
    template: hbs['settings/templates/board_settings']
    className: 'board-settings'

    initialize: (options) ->
      @fieldName = options.fieldName
      @setColumns options.columns
      super
      @updateTitle "Board Settings"
      @delegate 'click', '.board-column', @onColumnClick

    getTemplateData: ->
      projectName: app.session.getProjectName()
      fieldName: @fieldName
      columns: @columns

    setColumns: (@columns) ->

    onColumnClick: (e) ->
      @trigger 'columnClick', e.currentTarget.getAttribute('data-target')
