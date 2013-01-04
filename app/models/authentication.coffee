Model = require 'models/model'
User = require 'models/user'
ProjectCollection = require 'models/project_collection'

module.exports = Model.extend
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
    @project.get('_refObjectName')

  logout: ->
    $.cookie('ZSESSIONID', "")
    @set
      zsessionid: null