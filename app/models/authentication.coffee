Model = require 'models/model'
User = require 'models/user'

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

  logout: ->
    $.cookie('ZSESSIONID', "")
    @set
      zsessionid: null