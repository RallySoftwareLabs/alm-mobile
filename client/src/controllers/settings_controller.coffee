_ = require 'underscore'
Fluxxor = require 'fluxxor'
app = require 'application'
utils = require 'lib/utils'
UserStory = require 'models/user_story'
SiteController = require 'controllers/base/site_controller'
SettingsActions = require 'actions/settings_actions'
SettingsStore = require 'stores/settings_store'
SettingsView = require 'views/settings/settings'
BoardSettingsView = require 'views/settings/board_settings'

module.exports = class SettingsController extends SiteController

  show: (params) ->
    @whenProjectIsLoaded().then =>
      settingsStore = @_buildStore(app.session)
      
      flux = new Fluxxor.Flux({ SettingsStore: settingsStore }, SettingsActions)
      settingsStore.load()
      @renderReactComponent(SettingsView, region: 'main', flux: flux).then (view) =>
        @listenTo(view, 'boardFieldChange', @onChangeBoardField)
        @listenTo(view, 'changeProject', @onChangeProject)
        @listenTo(view, 'logout', @onLogout)
        @updateTitle "Settings: #{app.session.getProjectName()}"

  board: (params) ->
    @whenProjectIsLoaded().then =>
      settingsStore = @_buildStore(app.session)
      
      flux = new Fluxxor.Flux({ SettingsStore: settingsStore }, SettingsActions)
      settingsStore.load()
      boardField = app.session.getBoardField()
      @renderReactComponent(BoardSettingsView,
        region: 'main'
        flux: flux
      )

  onChangeBoardField: ->
    @redirectTo 'settings/board'

  onChangeProject: (view, projectRef) ->
    @updateTitle "Settings: #{app.session.getProjectName()}"

  onLogout: ->
    @redirectTo 'logout'

  _buildStore: (session) ->
    new SettingsStore({
      session: session
    })