define ->
  jqueryCookie = require 'jqueryCookie'
  Model = require 'models/base/model'
  User = require 'models/user'
  Projects = require 'collections/projects'

  class Session extends Model
    initialize: ->
      super
      @set
        user: new User()
        mode: $.cookie('mode') || 'team'
        boardField: $.cookie('boardField') || 'ScheduleState'
      @listenTo this, 'change:user', @_onUserChange
      @listenTo this, 'change:mode', @_onModeChange
      @listenTo this, 'change:boardField', @_onBoardFieldChange
      @listenTo this, 'change:project', @_onProjectChange

    authenticated: (cb) ->
      authCache = @get 'authenticated'
      return cb?(true) if authCache && cb?

      return authCache if !cb?

      $.ajax(
        url: '/getSessionInfo'
        type: 'GET'
        dataType: 'json'
        success: (data, status, xhr) =>
          @set
            jsessionid: $.cookie('JSESSIONID')
            securityToken: data.securityToken
            authenticated: true
          cb?(true)
        error: (xhr, errorType, error) =>
          cb?(false)
      )

    hasSecurityToken: ->
       Boolean(@get("securityToken"))

    hasSessionCookie: ->
      !!$.cookie('JSESSIONID')

    hasProjectCookie: ->
      !!$.cookie('project')

    getProjectName: ->
      try
        @get('project').get('_refObjectName')
      catch e
        ""

    isSelfMode: -> @get('mode') == 'self'
    isTeamMode: -> @get('mode') == 'team'

    getSecurityToken: ->
      @get 'securityToken'

    setSecurityToken: (securityToken) ->
      @set
        jsessionid: $.cookie('JSESSIONID')
        securityToken: securityToken

    logout: ->
      $.removeCookie('JSESSIONID', domain: window.AppConfig.cookieDomain)
      $.removeCookie('mblsessid')
      @set securityToken: null

    _onUserChange: (model, value, options) ->
      projects = new Projects()
      @set 'projects', projects
      projects.fetch
        success: (collection) =>
          if @hasProjectCookie()
            savedProjRef = $.cookie('project')
            savedProject = collection.find (proj) -> proj.get('_ref') == savedProjRef
            @set('project', savedProject) if savedProject

          if !@get 'project'
            @set 'project', collection.first()

          @publishEvent "projectready", @getProjectName()

    _onModeChange: (model, value, options) ->
      $.cookie('mode', value)

    _onBoardFieldChange: (model, value, options) ->
      $.cookie('boardField', value)

    _onProjectChange: (model, value, options) ->
      $.cookie('project', value.get('_ref'))