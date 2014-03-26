_ = require 'underscore'
appConfig = require 'app_config'
Model = require 'models/base/model'
Defect = require 'models/defect'
Task = require 'models/task'
UserStory = require 'models/user_story'

module.exports = class TypeDefinition extends Model
  typePath: 'typedefinition'
  urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/@@WSAPI_VERSION/typedefinition'

  initialize: ->
    super
    @listenTo this, 'sync', @onSync

  onSync: ->
    model = @getMatchingModel @get('TypePath').toLowerCase()

  getMatchingModel: (typePath) ->
    _.find [Defect, Task, UserStory], (model) -> model::typePath == typePath
