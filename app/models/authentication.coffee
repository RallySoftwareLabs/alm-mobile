Model = require 'models/model'

module.exports = Model.extend(
  defaults:
    zsessionid: null,
    jsessionid: null

  initialize: ->
    @load()

  authenticated: ->
    Boolean(@get("zsessionid"))

  load: ->
    @set
      zsessionid: $.fn.cookie('ZSESSIONID')
      jsessionid: $.fn.cookie('JSESSIONID')
)