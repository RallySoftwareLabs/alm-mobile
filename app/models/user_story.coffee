Model = require 'models/model'

module.exports = Model.extend
  urlRoot: window.AppConfig.almWebServiceBaseUrl + '/webservice/2.x/hierarchicalrequirements'
  defaults: {
    "Description" : "",
    "Name" : "New User Story",
    "Owner" : "",
    "PlanEstimate" : "",
    "ScheduleState" : "Defined"
  }