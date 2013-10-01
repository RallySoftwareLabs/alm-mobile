define ->
  $ = require 'jquery'
  _ = require 'underscore'
  app = require 'application'
  utils = require 'lib/utils'
  UserStory = require 'models/user_story'
  SiteController = require 'controllers/base/site_controller'
  SettingsView = require 'views/settings/settings_view'
  BoardSettingsView = require 'views/settings/board_settings_view'

  class SettingsController extends SiteController

    show: (params) ->
      @whenLoggedIn ->
        mode = app.session.get('mode')
        boardField = app.session.get('boardField')
        @view = new SettingsView region: 'main', autoRender: true
        @listenTo @view, 'changeMode', @onChangeMode
        @listenTo @view, 'changeBoardField', @onChangeBoardField
        @listenTo @view, 'changeProject', @onChangeProject
        @listenTo @view, 'changeIteration', @onChangeIteration
        @subscribeEvent 'projectready', => @view.render()

    board: (params) ->
      @whenLoggedIn ->
        fieldName = UserStory.getFieldDisplayName app.session.get('boardField')
        @view = new BoardSettingsView region: 'main', autoRender: true, fieldName: fieldName, columns: @_getColumnsForView()
        @listenTo @view, 'columnClick', @onColumnClick

    onChangeMode: (mode) ->
      app.session.set 'mode', mode

    onChangeBoardField: (boardField) ->
      app.session.set 'boardField', boardField
      @redirectToRoute 'settings#board'

    onChangeProject: (project) ->
      app.session.set 'project', _.find app.session.get('projects').models, _.isAttributeEqual '_ref', project

    onChangeIteration: (iteration) ->
      if iteration == 'null'
        return app.session.set 'iteration', null
      app.session.set 'iteration', _.find app.session.get('iterations').models, _.isAttributeEqual '_ref', iteration

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