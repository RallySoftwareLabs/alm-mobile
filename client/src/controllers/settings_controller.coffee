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
      @whenLoggedIn ->
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
      @whenLoggedIn ->
        fieldName = UserStory.getFieldDisplayName app.session.get('boardField')
        @view = @renderReactComponent BoardSettingsView,
          region: 'main'
          fieldName: fieldName
          model: app.session
        @subscribeEvent 'columnClick', @onColumnClick
        @markFinished()

    onChangeMode: (mode) ->
      app.aggregator.recordAction component: this, description: "changed mode to #{mode}"
      app.session.set 'mode', mode

    onChangeBoardField: (boardField) ->
      app.aggregator.recordAction component: this, description: "changed board field to #{boardField}"
      app.session.set 'boardField', boardField
      @redirectTo 'settings/board'

    onChangeProject: (projectRef) ->
      newProject = app.session.get('projects').find _.isAttributeEqual '_ref', projectRef
      app.aggregator.recordAction component: this, description: "changed project"
      app.session.set 'project', newProject
      @updateTitle "Settings: #{app.session.getProjectName()}"

    onChangeIteration: (iterationRef) ->
      if iterationRef == 'null'
        app.aggregator.recordAction component: this, description: "removed iteration"
        return app.session.set 'iteration', null

      newIteration = app.session.get('iterations').find _.isAttributeEqual '_ref', iterationRef
      app.aggregator.recordAction component: this, description: "set new iteration"
      app.session.set 'iteration', newIteration

    onColumnClick: (column) ->
      app.aggregator.recordAction component: this, description: "toggled column"
      app.session.toggleBoardColumn column

    onLogout: ->
      @redirectTo 'logout'