define ->
  appConfig = require 'appConfig'
  Model = require 'models/base/model'

  class Preference extends Model
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/preference'
    defaultProject: 'mobile.project.default'
    defaultIteration: 'mobile.iteration.default'
    defaultMode: 'mobile.mode.default'
    defaultBoardField: 'mobile.boardField.default'
    defaultBoardColumnsPrefix: 'mobile.boardColumns'
    acceptedLabsNotice: 'mobile.acceptedLabsNotice'
