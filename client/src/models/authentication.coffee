define ['models/model', 'models/user', 'models/project_collection'], (Model, User, ProjectCollection) ->

  Model.extend
    defaults:
      zsessionid: null

    initialize: ->
      @load()
      @user = new User()

    authenticated: ->
      Boolean(@get("zsessionid"))

    load: ->
      @set
        zsessionid: $.cookie('ZSESSIONID')

    setUser: (@user) ->
      @projects = new ProjectCollection()
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


    logout: ->
      $.cookie('ZSESSIONID', "")
      @set
        zsessionid: null