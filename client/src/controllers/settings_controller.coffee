define ->
  $ = require 'jquery'
  _ = require 'underscore'
  app = require 'application'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  SettingsView = require 'views/settings/settings_view'
  BoardSettingsView = require 'views/settings/board_settings_view'

  class SettingsController extends SiteController

    show: (params) ->
      @afterProjectLoaded ->
        mode = app.session.get('mode')
        boardField = app.session.get('boardField')
        @view = new SettingsView region: 'main', autoRender: true, mode: mode, boardField: boardField
        @listenTo @view, 'changeMode', @onChangeMode
        @listenTo @view, 'changeBoardField', @onChangeBoardField
        @listenTo @view, 'changeProject', @onChangeProject
        @subscribeEvent 'projectready', => @view.render()

    board: (params) ->
      @afterProjectLoaded ->
        
        @view = new BoardSettingsView region: 'main', autoRender: true, columns: @_getColumnsForView()
        @listenTo @view, 'columnClick', @onColumnClick

    onChangeMode: (mode) ->
      app.session.set 'mode', mode

    onChangeBoardField: (boardField) ->
      app.session.set 'boardField', boardField
      @redirectToRoute 'settings#board'

    onChangeProject: (project) ->
      app.session.set 'project', app.session.get('projects').find (proj) -> proj.get('_ref') == project

    onColumnClick: (column) ->
      app.session.toggleBoardColumn column
      @view.setColumns @_getColumnsForView()
      @view.render()

    _getColumnsForView: ->
      boardField = app.session.get('boardField')
      shownColumns = app.session.getBoardColumns()
      allColumns = UserStory.getAllowedValues boardField

      columns = _.map allColumns, (col) ->
        {
          StringValue: col.StringValue
          showing: _.contains shownColumns, col.StringValue
        }