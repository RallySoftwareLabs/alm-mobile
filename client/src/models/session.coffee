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

          @fetchUserInfo (err, model) =>
            if err?
              @logout 
                success: (data, status, xhr) ->
                  cb?(true)
                error: (xhr, errorType, error) ->
                  cb?(false)
            else
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

    logout: (options = {}) ->
      $.ajax(
        url: "#{window.AppConfig.almWebServiceBaseUrl}/resources/jsp/security/logout.jsp"
        type: 'GET'
        dataType: 'html'
      )
      $.ajax(
        url: Backbone.history.root + 'logout'
        type: 'POST'
        dataType: 'json'
        success: options.success
        error: options.error
      )
      @set securityToken: null
          
    fetchUserInfo: (cb) ->
      u = new User()
      u.fetch
        url: "#{u.urlRoot}:current"
        headers:
          "X-Requested-By": "Rally"
        params:
          fetch: 'ObjectID,DisplayName'
        success: (model, resp, opts) =>
          @set 'user', model
          cb?(null, model)
        error: (model, resp, options) =>
          cb?('auth', model)

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
      $.cookie('mode', value, path: '/')

    _onBoardFieldChange: (model, value, options) ->
      $.cookie('boardField', value, path: '/')

    _onProjectChange: (model, value, options) ->
      $.cookie('project', value.get('_ref'), path: '/')