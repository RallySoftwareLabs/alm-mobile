define ->
  $ = require 'jquery'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  SettingsView = require 'views/settings/settings_view'

  class SettingsController extends SiteController

    show: (params) ->
      @afterProjectLoaded ->
        mode = app.session.get('mode')
        boardField = app.session.get('boardField')
        @view = new SettingsView region: 'main', mode: mode, boardField: boardField
        @listenTo @view, 'changeMode', @onChangeMode
        @listenTo @view, 'changeBoardField', @onChangeBoardField

    onChangeMode: (mode) ->
      app.session.set 'mode', mode

    onChangeBoardField: (boardField) ->
      app.session.set 'boardField', boardField
