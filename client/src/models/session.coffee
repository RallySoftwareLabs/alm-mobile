define ->
  jqueryBase64 = require 'jqueryBase64'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  Model = require 'models/base/model'
  User = require 'models/user'
  Preference = require 'models/preference'
  UserStory = require 'models/user_story'
  UserProfile = require 'models/user_profile'
  Schema = require 'collections/schema'
  Iterations = require 'collections/iterations'
  Preferences = require 'collections/preferences'
  Projects = require 'collections/projects'
  Users = require 'collections/users'

  class Session extends Model
    initialize: (@clientMetricsParent, @aggregator) ->
      super
      @set
        securityToken: window.sessionStorage.getItem 'token'
      @listenTo this, 'change:user', @_onUserChange
      @listenTo this, 'change:mode', @_onModeChange
      @listenTo this, 'change:boardField', @_onBoardFieldChange
      @listenTo this, 'change:project', @_onProjectChange
      @listenTo this, 'change:iteration', @_onIterationChange

    authenticated: (cb) ->
      if !@get('securityToken')
        return cb? false

      @fetchUserInfo (err, user) =>
        preferences = new Preferences()
        preferences.clientMetricsParent = this
        @set 'prefs', preferences
        preferences.fetchMobilePrefs(user).then =>
          cb? !err?

    authenticate: (username, password, cb) ->
      $.ajax(
        url: "#{appConfig.almWebServiceBaseUrl}/webservice/@@WSAPI_VERSION/security/authorize"
        type: 'GET'
        dataType: 'json'
        xhrFields:
          withCredentials: true
        beforeSend: (xhr) ->
          xhr.setRequestHeader("Authorization", """Basic #{$.base64.encode(username + ':' + password)}""")
          xhr.setRequestHeader("X-Requested-By", "Rally")
          xhr.setRequestHeader("X-RallyIntegrationName", appConfig.appName)
        success: (data, status, xhr) =>
          if data.OperationResult.Errors.length > 0
            return cb? false

          @setUsername username
          @setSecurityToken data.OperationResult.SecurityToken

          @authenticated cb
        error: (xhr, errorType, error) =>
          cb? false
      )

    initSessionForUser: (projectRef) ->
      user = @get('user')
      return unless user?
      @aggregator.beginLoad component: this, description: 'session init'

      Projects.fetchAll().then (p) =>
        projects = Projects::projects
        @_setModeFromPreference()
        if projectRef
          specifiedProject = projects.find _.isAttributeEqual('_ref', projectRef)
          @set('project', specifiedProject) if specifiedProject
        else
          @_setDefaultProject projects

    getProjectName: ->
      try
        @get('project').get('_refObjectName')
      catch e
        ""

    isSelfMode: -> @get('mode') == 'self'
    isTeamMode: -> @get('mode') == 'team'

    setSecurityToken: (securityToken) ->
      @set 'securityToken', securityToken
      window.sessionStorage.setItem 'token', if securityToken then securityToken else ''

    getSecurityToken: ->
      @get 'securityToken'

    setUsername: (username) ->
      window.sessionStorage.setItem 'username', if username then username else ''

    getUsername: ->
      window.sessionStorage.getItem 'username'

    hasAcceptedLabsNotice: ->
      @get('prefs').findPreference(Preference::acceptedLabsNotice)?

    acceptLabsNotice: ->
      @aggregator.beginLoad component: this, description: 'accepting labs notics'
      $.when(
        @get('prefs').updatePreference @get('user'), Preference::acceptedLabsNotice, true
      )

    logout: (options = {}) ->
      @setSecurityToken null
      @setUsername null
      @clear silent: true

      window.sessionStorage.removeItem('username')
      window.sessionStorage.removeItem('token')
      for key of window.sessionStorage
        window.sessionStorage.removeItem(key) if key.indexOf('iteration.') == 0

      @aggregator.beginLoad component: this, description: 'logging out'
      $.ajax(
        url: "#{appConfig.almWebServiceBaseUrl}/resources/jsp/security/clear.jsp"
        type: 'GET'
        dataType: 'html'
        beforeSend: (xhr) ->
          xhr.setRequestHeader("X-Requested-By", "Rally")
          xhr.setRequestHeader("X-RallyIntegrationName", appConfig.appName)
      ).always => @aggregator.endLoad component: this
          
    fetchUserInfo: (cb) ->
      user = new User()
      user.clientMetricsParent = this
      @aggregator.beginLoad component: this, description: 'fetching logged-in user'

      user.fetchSelf (err, u) =>
        @aggregator.endLoad component: this
        unless err?
          @set 'user', u
        cb(err, u)

    initColumnsFor: (boardField) ->
      pref = "#{Preference::defaultBoardColumnsPrefix}.#{boardField}"
      savedColumns = @get('prefs').findProjectPreference(@get('project').get('_ref'), pref)
      if savedColumns
        columns = savedColumns.get 'Value'

      visibleColumns = if columns then columns.split ',' else @_getDefaultBoardColumns(boardField)
      $.when(visibleColumns).then (cols) =>
        @setBoardColumns boardField, cols
      visibleColumns

    getBoardColumns: (boardField = @get('boardField')) ->
      pref = "#{Preference::defaultBoardColumnsPrefix}.#{boardField}"
      projectOid = utils.getOidFromRef @get('project').get('_ref')
      columns = @get "#{pref}.#{projectOid}"

      unless columns
        columns = @initColumnsFor boardField

      columns

    toggleBoardColumn: (column, boardField = @get('boardField')) ->
      shownColumns = @getBoardColumns boardField

      newColumns = if _.contains(shownColumns, column)
        _.without(shownColumns, column)
      else
        UserStory.getAllowedValues(boardField).then (allowedValues) =>
          columns = _.pluck(allowedValues, 'StringValue')

          _.intersection(columns, shownColumns.concat([column]))

      $.when(newColumns).then (cols) =>
        @setBoardColumns boardField, cols

    setBoardColumns: (boardField, columns) ->
      @aggregator.beginLoad component: this, description: 'saving board columns'
      pref = "#{Preference::defaultBoardColumnsPrefix}.#{boardField}"
      projectOid = utils.getOidFromRef @get('project').get('_ref')

      @set "#{pref}.#{projectOid}", columns
      @get('prefs').updateProjectPreference(
        @get('user').get('_ref'),
        @get('project').get('_ref'),
        pref,
        columns.join(',')
      ).always => @aggregator.endLoad component: this

    _getDefaultBoardColumns: (boardField) ->
      switch boardField
        when 'ScheduleState' then _(UserStory.getAllowedValues(boardField)).pluck('StringValue').compact().value()
        else []

    _setDefaultProject: (projects) ->
      defaultProject = @get('prefs').findPreference(Preference::defaultProject)
      if defaultProject
        savedProject = projects.find _.isAttributeEqual('_ref', defaultProject.get('Value'))
        @set('project', savedProject) if savedProject

      if !@get 'project'
        defaultProject = @get('user').get('UserProfile').DefaultProject._ref
        proj = projects.find _.isAttributeEqual('_ref', defaultProject)
        @set 'project', proj || projects.first()

    _setModeFromPreference: ->
      mode = 'team'
      savedMode = @get('prefs').findPreference Preference::defaultMode
      if savedMode
        mode = savedMode.get 'Value'

      @set 'mode', mode

    _setBoardFieldFromPreference: ->
      boardField = 'ScheduleState'
      savedBoardField = @get('prefs').findProjectPreference @get('project').get('_ref'), Preference::defaultBoardField
      if savedBoardField
        boardField = savedBoardField.get 'Value'

      @set 'boardField', boardField

    loadSchema: (project) ->
      schema = new Schema()
      schema.clientMetricsParent = this
      @set('schema', schema)
      schema.fetchForProject(project)

    _onModeChange: (model, value, options) ->
      @get('prefs').updatePreference @get('user'), Preference::defaultMode, value

    _onBoardFieldChange: (model, value, options) ->
      @get('prefs').updateProjectPreference @get('user').get('_ref'), @get('project').get('_ref'), Preference::defaultBoardField, value

    _onProjectChange: (model, value, options) ->
      @aggregator.beginLoad component: this, description: 'on project change'
      projectRef = value.get('_ref')
      prefs = @get('prefs')

      @_setBoardFieldFromPreference()

      prefs.updatePreference @get('user'), Preference::defaultProject, projectRef

      iterations = new Iterations()
      iterations.clientMetricsParent = this
      @set 'iterations', iterations

      $.when(
        @loadSchema(value),
        iterations.fetchAllPages(
          data:
            fetch: 'Name,StartDate,EndDate'
            order: 'StartDate DESC,EndDate DESC,ObjectID'
            query: "(Project = \"#{projectRef}\")"
        )
      ).then (s, i) =>
        @initColumnsFor @get('boardField')
        @_setSessionIteration()
        @aggregator.endLoad component: this
        @publishEvent "projectready", @getProjectName()

    _onIterationChange: (model, value, options) ->
      iterationRef = value?.get('_ref')
      projectOid = utils.getOidFromRef(@get('project').get('_ref'))
      window.sessionStorage.setItem "iteration.#{projectOid}", iterationRef

    _setSessionIteration: ->
      projectOid = utils.getOidFromRef(@get('project').get('_ref'))
      savedIteration = window.sessionStorage.getItem "iteration.#{projectOid}"
      iterations = @get('iterations')

      iteration = if savedIteration
        iterations.find _.isAttributeEqual('_ref', savedIteration)
      else
        iterations.findClosestAsCurrent()

      @set('iteration', iteration)

    _asClientMetricsParent: -> clientMetricsParent: this
