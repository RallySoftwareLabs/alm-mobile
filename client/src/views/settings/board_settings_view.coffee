define ->
  _ = require 'underscore'
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class BoardSettingsView extends PageView
    template: hbs['settings/templates/board_settings']

    initialize: (options) ->
      @setColumns options.columns
      super
      @delegate 'click', '.board-column', @onColumnClick

    getTemplateData: ->
      columns: @columns

    setColumns: (@columns) ->

    onColumnClick: (e) ->
      @trigger 'columnClick', e.currentTarget.getAttribute('data-target')
