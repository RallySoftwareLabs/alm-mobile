Model = require 'models/model'

module.exports = Model.extend
  initialize: (options) ->
    @setUrlRoot(options)

  setUrlRoot: (options) ->
    @urlRoot = window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/hierarchicalrequirements'
    unless options?.ObjectID?
      @urlRoot += '/create'

  defaults: {
    "ScheduleState" : "Defined"
  }
