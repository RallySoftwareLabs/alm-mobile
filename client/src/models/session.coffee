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

    setProject: (@project) ->

    getProjectName: ->
      try
        @project.get('_refObjectName')
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
      @set securityToken: null

    _onUserChange: (model, value, options) ->
      @projects = new Projects()
      @projects.fetch
        success: (collection) =>
          @setProject collection.first()
          @publishEvent "projectready", @getProjectName()
          @publishEvent 'loadedSettings'

    _onModeChange: (model, value, options) ->
      $.cookie('mode', value, cookieDomain: window.AppConfig.cookieDomain)

    _onBoardFieldChange: (model, value, options) ->
      $.cookie('boardField', value, cookieDomain: window.AppConfig.cookieDomain)