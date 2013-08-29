define ->
  _ = require 'underscore'
  hbs = require 'hbsTemplate'
  app = require 'application'
  PageView = require 'views/base/page_view'

  class SettingsView extends PageView
    template: hbs['settings/templates/settings']

    events:
      'click .logout button': 'triggerLogout'
      'change select.project-select': 'updateSelectedProject'
      'change select.iteration-select': 'updateSelectedIteration'

    initialize: (options) ->
      super
      @updateTitle "Settings"
      @delegate 'click', '.self', => @changeMode 'self'
      @delegate 'click', '.team', => @changeMode 'team'
      @delegate 'click', '.schedule-state', => @changeBoardField 'ScheduleState'
      @delegate 'click', '.kanban-state', => @changeBoardField 'c_KanbanState'

    getTemplateData: ->
      iteration = app.session.get('iteration')
      mode = app.session.get('mode')
      boardField = app.session.get('boardField')
      return {
        projects: app.session.get('projects')?.models
        currentProject: app.session.get('project').get('_ref')
        iterations: app.session.get('iterations')?.models
        currentIteration: iteration?.get('_ref')
        noCurrentIteration: !iteration?
        isTeam: mode == 'team'
        isSelf: mode == 'self'
        isScheduleState: boardField == 'ScheduleState'
        isKanbanState: boardField == 'c_KanbanState'
      }

    triggerLogout: ->
      @publishEvent '!router:routeByName', 'auth#logout'

    changeMode: (mode) ->
      @trigger 'changeMode', mode
      @render()

    changeBoardField: (boardField) ->
      @trigger 'changeBoardField', boardField
      @render()

    updateSelectedProject: ->
      @trigger 'changeProject', @$('.project-select option:selected').val()

    updateSelectedIteration: ->
      @trigger 'changeIteration', @$('.iteration-select option:selected').val()
