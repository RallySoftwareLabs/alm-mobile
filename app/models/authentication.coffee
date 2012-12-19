Model = require 'models/model'

module.exports = Model.extend
  defaults:
    zsessionid: null

  initialize: ->
    @load()

  authenticated: ->
    Boolean(@get("zsessionid"))

  load: ->
    @set
      zsessionid: $.cookie('ZSESSIONID')

  logout: ->
    $.cookie('ZSESSIONID', "")
    @set
      zsessionid: null