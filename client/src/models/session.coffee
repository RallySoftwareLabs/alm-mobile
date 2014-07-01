$ = require 'jquery';
Promise = require('es6-promise').Promise
appConfig = require 'app_config'
utils = require 'lib/utils'
Model = require 'models/base/model'
User = require 'models/user'
Preference = require 'models/preference'
UserStory = require 'models/user_story'
UserProfile = require 'models/user_profile'
Workspace = require 'models/workspace'
Schema = require 'collections/schema'
Iterations = require 'collections/iterations'
Preferences = require 'collections/preferences'
Projects = require 'collections/projects'
Users = require 'collections/users'

module.exports = class Session extends Model
  initialize: (@clientMetricsParent, @aggregator) ->
    super
    @set
      securityToken: window.sessionStorage.getItem 'token'
      boardColumns: {}

    @listenTo this, 'change:user', @_onUserChange
    @listenTo this, 'change:mode', @_onModeChange
    @listenTo this, 'change:project', @_onProjectChange
    @listenTo this, 'change:iteration', @_onIterationChange

  authenticated: (cb) ->
    return cb? false if !@get('securityToken')
    return cb? true if @get('user')

    @aggregator.beginLoad component: this, description: 'fetching logged-in user and prefs'
    @_fetchUserInfo (err, user) =>
      cb? false if err?
      preferences = new Preferences()
      preferences.clientMetricsParent = this
      @set 'prefs', preferences

      preferences.fetchMobilePrefs(user).then =>
        @aggregator.endLoad component: this
        cb? true

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

    projectRef ?= @_getDefaultProjectRef()

    if projectRef
      projects = new Projects()
      projectPromise = projects.fetch(data:
        shallowFetch: 'Name,Parent,Workspace,SchemaVersion'
        query: "(ObjectID = #{utils.getOidFromRef(projectRef)})"
      ).then ->
        projects.first()
    else
      projectPromise = Projects.fetchAll().then (projects) =>
        projects.first()

    @_setModeFromPreference()
    projectPromise.then (specifiedProject) =>
      @set('project', specifiedProject)

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
    @get('prefs').updatePreference @get('user'), Preference::acceptedLabsNotice, true

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
        
  _fetchUserInfo: (cb) ->
    user = new User()
    user.clientMetricsParent = this

    user.fetchSelf (err, u) =>
      unless err?
        @set 'user', u
      cb(err, u)

  getBoardField: ->
    boardField = 'ScheduleState'
    savedBoardField = @get('prefs').findProjectPreference @get('project').get('_ref'), Preference::defaultBoardField
    if savedBoardField
      boardField = savedBoardField.get 'Value'

    boardField

  setBoardField: (boardField) ->
    @aggregator.beginLoad component: this, description: 'saving board field'
    projectRef = @get('project').get('_ref')
    @get('prefs').updateProjectPreference(
      @get('user').get('_ref'),
      projectRef,
      Preference::defaultBoardField,
      boardField
    ).then =>
      @aggregator.endLoad component: this
      this.trigger('change')

  # Returns a promise
  getBoardColumns: (boardField = @getBoardField()) ->
    columns = @_getSavedBoardColumns(boardField) || @_getDefaultBoardColumns(boardField)
    Promise.resolve(columns)

  toggleBoardColumn: (column, boardField = @getBoardField()) ->
    shownColumns = @_getSavedBoardColumns(boardField) || []

    newColumns = if _.contains(shownColumns, column)
      _.without(shownColumns, column)
    else
      UserStory.getAllowedValues(boardField).then (allowedValues) =>
        columns = _.pluck(allowedValues, 'StringValue')

        _.intersection(columns, shownColumns.concat([column]))

    Promise.resolve(newColumns).then (cols) =>
      @setBoardColumns boardField, cols
      cols

  setBoardColumns: (boardField, columns) ->
    @aggregator.beginLoad component: this, description: 'saving board columns'
    pref = "#{Preference::defaultBoardColumnsPrefix}.#{boardField}"
    projectRef = @get('project').get('_ref')

    @get('prefs').updateProjectPreference(
      @get('user').get('_ref'),
      projectRef,
      pref,
      columns.join(',')
    ).then =>
      @aggregator.endLoad component: this

  _getSavedBoardColumns: (boardField) ->
    pref = "#{Preference::defaultBoardColumnsPrefix}.#{boardField}"
    columnPref = @get('prefs').findProjectPreference(
      @get('project').get('_ref'),
      pref
    )
    if columnPref 
      value = columnPref.get('Value')
      if value
        columns = value.split(',')

    columns

  _getDefaultBoardColumns: (boardField) ->
    switch boardField
      when 'ScheduleState'
        UserStory.getAllowedValues(boardField).then (allowedValues) ->
          _(allowedValues).pluck('StringValue').compact().value()
      else []

  _getDefaultProjectRef: ->
    defaultProjectPref = @get('prefs').findPreference(Preference::defaultProject)
    if defaultProjectPref
      return defaultProjectPref.get('Value')
    
    @get('user').get('UserProfile').DefaultProject._ref

    if !@get 'project'
      defaultProject = @get('user').get('UserProfile').DefaultProject._ref

  _setModeFromPreference: ->
    mode = 'team'
    savedMode = @get('prefs').findPreference Preference::defaultMode
    if savedMode
      mode = savedMode.get 'Value'

    @set(mode: mode, trigger: false)

  loadSchema: (project) ->
    schema = new Schema()
    schema.clientMetricsParent = this
    @set('schema', schema)
    schema.fetchForProject(project)

  _onModeChange: (model, value, options) ->
    @get('prefs').updatePreference @get('user'), Preference::defaultMode, value

  _onProjectChange: (model, value, options) ->
    @aggregator.beginLoad component: this, description: 'on project change'
    projectRef = value.get('_ref')
    prefs = @get('prefs')

    prefs.updatePreference @get('user'), Preference::defaultProject, projectRef

    iterations = new Iterations()
    iterations.clientMetricsParent = this
    @set 'iterations', iterations

    Promise.all([
      @loadSchema(value),
      iterations.fetchAllPages(
        data:
          fetch: 'Name,StartDate,EndDate,PlannedVelocity'
          order: 'StartDate DESC,EndDate DESC,ObjectID'
          query: "(Project = \"#{projectRef}\")"
      )
    ]).then (s, i) =>
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
