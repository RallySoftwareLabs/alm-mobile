define ->
  $ = require 'jquery'
  _ = require 'underscore'
  app = require 'application'
  utils = require 'lib/utils'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  SettingsView = require 'views/settings/settings'
  BoardSettingsView = require 'views/settings/board_settings'

  class SettingsController extends SiteController

    show: (params) ->
      @whenProjectIsLoaded ->
        @view = @renderReactComponent SettingsView, region: 'main', model: app.session
        @subscribeEvent 'changeMode', @onChangeMode
        @subscribeEvent 'changeBoardField', @onChangeBoardField
        @subscribeEvent 'changeProject', @onChangeProject
        @subscribeEvent 'changeIteration', @onChangeIteration
        @subscribeEvent 'logout', @onLogout
        @subscribeEvent 'projectready', => @view.forceUpdate()
        @updateTitle "Settings: #{app.session.getProjectName()}"
        @markFinished()

    board: (params) ->
      @whenProjectIsLoaded ->
        fieldName = UserStory.getFieldDisplayName app.session.get('boardField')
        @view = @renderReactComponent BoardSettingsView,
          region: 'main'
          fieldName: fieldName
          model: app.session
        @subscribeEvent 'columnClick', @onColumnClick
        @markFinished()

    onChangeMode: (mode) ->
      app.session.set 'mode', mode

    onChangeBoardField: (boardField) ->
      app.session.set 'boardField', boardField
      @redirectTo 'settings/board'

    onChangeProject: (projectRef) ->
      newProject = app.session.get('projects').find _.isAttributeEqual '_ref', projectRef
      app.session.set 'project', newProject
      @updateTitle "Settings: #{app.session.getProjectName()}"

    onChangeIteration: (iterationRef) ->
      newIteration = if iterationRef == 'null'
        null
      else
        app.session.get('iterations').find _.isAttributeEqual '_ref', iterationRef
      
      app.session.set 'iteration', newIteration

    onColumnClick: (column) ->
      app.session.toggleBoardColumn column

    onLogout: ->
      @redirectTo 'logout'