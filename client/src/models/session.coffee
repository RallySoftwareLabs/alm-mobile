define ->
  jqueryCookie = require 'jqueryCookie'
  utils = require 'lib/utils'
  Model = require 'models/base/model'
  User = require 'models/user'
  Defect = require 'models/defect'
  Task = require 'models/task'
  UserStory = require 'models/user_story'
  UserProfile = require 'models/user_profile'
  Schema = require 'collections/schema'
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
            rallySession: data.jsessionid
            securityToken: data.securityToken
            authenticated: true

          @fetchUserInfo (err, model) =>
            cb? !err?
        error: (xhr, errorType, error) =>
          cb? false
      )

    hasSecurityToken: ->
       Boolean(@get("securityToken"))

    hasSessionCookie: ->
      !!@get('rallySession')

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

    setSecurityToken: (jsessionid, securityToken) ->
      @set
        rallySession: jsessionid
        securityToken: securityToken

    logout: (options = {}) ->
      @set securityToken: null, rallySession: null
      $.when(
        $.ajax(
          url: "#{window.AppConfig.almWebServiceBaseUrl}/resources/jsp/security/clear.jsp"
          type: 'GET'
          dataType: 'html'
        )
        $.ajax(
          url: '/logout'
          type: 'POST'
          dataType: 'json'
          success: options.success
          error: options.error
        )
      )
          
    fetchUserInfo: (cb) ->
      u = new User()
      u.fetch
        url: "#{u.urlRoot}:current"
        headers:
          "X-Requested-By": "Rally"
        params:
          fetch: 'ObjectID,DisplayName,UserProfile'
        success: (model, resp, opts) =>
          @set 'user', model
          cb?(null, model)
        error: (model, resp, options) =>
          cb?('auth', model)

    _onUserChange: (model, value, options) ->
      projects = new Projects()
      @set 'projects', projects

      userProfile = new UserProfile
        ObjectID: utils.getOidFromRef(@get('user').get('UserProfile')._ref)

      pagesize = 200
      $.when(
        projects.fetch(
          data:
            pagesize: pagesize
            order: 'Name'
        ),
        userProfile.fetch()
      ).done (p, u) =>
        totalProjectResults = p[0].QueryResult.TotalResultCount
        @_fetchRestOfProjects(projects, pagesize, totalProjectResults).done =>
          @_setDefaultProject projects, userProfile

    _fetchRestOfProjects: (projects, pagesize, totalCount) ->
      start = pagesize + 1
      projectFetches = while totalCount >= start
        fetch = projects.fetch(
          remove: false
          data:
            start: start
            pagesize: pagesize
            order: 'Name'
        )
        start += pagesize
        fetch

      $.when.apply($, projectFetches)

    _setDefaultProject: (projects, userProfile) ->
      if @hasProjectCookie()
        savedProjRef = $.cookie('project')
        savedProject = projects.find (proj) -> proj.get('_ref') == savedProjRef
        @set('project', savedProject) if savedProject

      if !@get 'project'
        defaultProject = userProfile.get('DefaultProject')?._ref
        proj = projects.find (proj) -> proj.get('_ref') == defaultProject
        @set 'project', proj || projects.first()


    _loadSchema: (project) ->
      projectRef = project.get('_ref')
      projectOid = utils.getOidFromRef projectRef

      schema = new Schema()
      schema.url = "/schema/#{projectOid}"
      schema.fetch(accepts: json: 'text/plain').done =>
        $.when.apply($, _.map [Defect, Task, UserStory], (model) -> model.updateFromSchema(schema))

    _onModeChange: (model, value, options) ->
      $.cookie('mode', value, path: '/')

    _onBoardFieldChange: (model, value, options) ->
      $.cookie('boardField', value, path: '/')

    _onProjectChange: (model, value, options) ->
      projectRef = value.get('_ref')
      projectOid = utils.getOidFromRef projectRef

      $.cookie('project', projectRef, path: '/')

      $.when(@_loadSchema(value)).then =>
        @publishEvent "projectready", @getProjectName()
