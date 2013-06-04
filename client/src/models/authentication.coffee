define [
  'chaplin'
  'jqueryCookie'
  'models/model'
  'models/user'
  'collections/projects'
], (Chaplin, jqueryCookie, Model, User, Projects) ->

  Model.extend
    initialize: ->
      @user = new User()

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
            # zsessionid: $.cookie('ZSESSIONID')
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

    setUser: (@user) ->
      @projects = new Projects()
      @projects.fetch
        success: (collection) =>
          @setProject collection.first()
          Chaplin.mediator.publish "projectready", @getProjectName()
          Chaplin.mediator.publish 'loadedSettings'

    setProject: (@project) ->

    getProjectName: ->
      try
        @project.get('_refObjectName')
      catch e
        ""

    getSecurityToken: ->
      @get 'securityToken'

    setSecurityToken: (securityToken) ->
      @set
        # zsessionid: $.cookie('ZSESSIONID')
        jsessionid: $.cookie('JSESSIONID')
        securityToken: securityToken

    logout: ->
      # $.cookie('ZSESSIONID', "")
      $.cookie('JSESSIONID', "")
      @set securityToken: null