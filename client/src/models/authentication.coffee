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

    authenticated: (cb) ->
      $.ajax(
        url: Backbone.history.root + 'getSessionInfo'
        type: 'GET'
        dataType: 'json'
        success: (data, status, xhr) =>
          @set
            zsessionid: $.cookie('ZSESSIONID')
            jsessionid: $.cookie('JSESSIONID')
            securityToken: data.securityToken
          cb?(true)
        error: (xhr, errorType, error) =>
          cb?(false)
      )

    hasSecurityToken: ->
       Boolean(@get("securityToken"))

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

    setSecurityToken: (securityToken) ->
      @set
        zsessionid: $.cookie('ZSESSIONID')
        jsessionid: $.cookie('JSESSIONID')
        securityToken: securityToken

    logout: ->
      $.cookie('ZSESSIONID', "")
      $.cookie('JSESSIONID', "")
      @set zsessionid: null, securityToken: null