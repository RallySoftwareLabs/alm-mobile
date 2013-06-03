define [
  'jqueryCookie'
  'models/model'
  'models/user'
  'collections/projects'
], (jqueryCookie, Model, User, Projects) ->

  Model.extend
    defaults:
      zsessionid: null

    initialize: ->
      @user = new User()

    authenticated: ->
      Boolean(@get("zsessionid")) && Boolean(@get("securityToken")) && Boolean(@get("jsessionid"))

    load: (securityToken, cb) ->
      @set securityToken: securityToken

      zsessionid = $.cookie('ZSESSIONID')
      jsessionid = $.cookie('JSESSIONID')
      if zsessionid && jsessionid
        @set zsessionid: zsessionid
        @set jsessionid: jsessionid

      cb(null)
      #   base64Auth = $.base64.encode "#{username}:#{password}"
      #   # Get CSRF Token
      #   $.ajax(
      #     url: "#{window.AppConfig.almWebServiceBaseUrl}/webservice/v2.x/security/authorize"
      #     type: 'GET'
      #     dataType: 'json'
      #     # crossDomain: true
      #     beforeSend: (xhr) ->
      #       xhr.setRequestHeader("Authorization", "Basic " + base64Auth)
      #       xhr.withCredentials = true
      #     headers:
      #     #   Authentication: "Basic #{base64Auth}"
      #       ZSESSIONID: zsessionid
      #     success: (data, status, xhr) =>
      #       @set securityToken: data.OperationResult.SecurityToken
      #       cb(null)

      #     error: (xhr, errorType, error) =>
      #       cb('Unable to fetch CSRF token.')
      #   )

    setUser: (@user) ->
      @projects = new Projects()
      @projects.fetch
        success: (collection) =>
          @setProject collection.first()
          Backbone.trigger "projectready", @getProjectName()
          Backbone.trigger 'loadedSettings'

    setProject: (@project) ->

    getProjectName: ->
      try
        @project.get('_refObjectName')
      catch e
        ""

    getSecurityToken: ->
      @get 'securityToken'

    logout: ->
      $.cookie('ZSESSIONID', "")
      $.cookie('JSESSIONID', "")
      @set zsessionid: null, securityToken: null