define ->
  $ = require 'jquery'
  app = require 'application'
  SiteController = require 'controllers/base/site_controller'
  SettingsView = require 'views/settings/settings_view'

  class SettingsController extends SiteController

    show: (params) ->
      @afterProjectLoaded ->
        mode = app.session.get('mode')
        @view = new SettingsView region: 'main', mode: mode
        @listenTo @view, 'toggleMode', @onToggleMode

    onToggleMode: (mode) ->
      app.session.set 'mode', mode
