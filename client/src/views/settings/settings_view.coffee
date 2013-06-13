define ->
  _ = require 'underscore'
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class SettingsView extends PageView
    template: hbs['settings/templates/settings']

    events:
      'click button.logout': 'triggerLogout'
      'change select.project': 'updateSelectedProject'

    initialize: (options) ->
      @mode = options.mode
      @boardField = options.boardField
      super
      @updateTitle "Settings"
      @delegate 'click', '.self', => @changeMode 'self'
      @delegate 'click', '.team', => @changeMode 'team'
      @delegate 'click', '.schedule-state', => @changeBoardField 'ScheduleState'
      @delegate 'click', '.kanban-state', => @changeBoardField 'c_KanbanState'

    getTemplateData: ->
      projects: app.session.get('projects')?.models
      currentProject: app.session.get('project').get('_ref')
      isTeam: @mode == 'team'
      isSelf: @mode == 'self'
      isScheduleState: @boardField == 'ScheduleState'
      isKanbanState: @boardField == 'c_KanbanState'

    triggerLogout: ->
      @publishEvent '!router:routeByName', 'auth#logout'

    changeMode: (mode) ->
      @mode = mode
      @trigger 'changeMode', mode
      @render()

    changeBoardField: (boardField) ->
      @boardField = boardField
      @trigger 'changeBoardField', boardField
      @render()

    updateSelectedProject: ->
      @trigger 'changeProject', @$('option:selected').val()
