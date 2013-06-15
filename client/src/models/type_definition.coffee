define ->
  _ = require 'underscore'
  appConfig = require 'appConfig'
  Model = require 'models/base/model'
  Defect = require 'models/defect'
  Task = require 'models/task'
  UserStory = require 'models/user_story'

  class TypeDefinition extends Model
    typePath: 'typedefinition'
    urlRoot: appConfig.almWebServiceBaseUrl + '/webservice/v2.x/typedefinition'

    initialize: ->
      super
      @listenTo this, 'sync', @onSync

    onSync: ->
      model = @getMatchingModel @get('TypePath').toLowerCase()

    getMatchingModel: (typePath) ->
      _.find [Defect, Task, UserStory], (model) -> model::typePath == typePath
