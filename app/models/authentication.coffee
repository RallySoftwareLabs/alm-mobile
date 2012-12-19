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
      zsessionid: $.fn.cookie('ZSESSIONID')

  logout: ->
    $.fn.cookie('ZSESSIONID', "")
    @set
      zsessionid: null