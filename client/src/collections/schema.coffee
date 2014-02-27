define ->
  $ = require 'jquery'
  _ = require 'underscore'
  appConfig = require 'appConfig'
  utils = require 'lib/utils'
  AllowedValues = require 'collections/allowed_values'
  Collection = require 'collections/collection'
  Defect = require 'models/defect'
  Initiative = require 'models/initiative'
  Task = require 'models/task'
  TypeDefinition = require 'models/type_definition'
  UserStory = require 'models/user_story'

  class Schema extends Collection
    typePath: '__schema__'
    url: appConfig.almWebServiceBaseUrl + '/schema/@@WSAPI_VERSION/project'
    model: TypeDefinition

    fetchForProject: (project) ->
      projectOid = utils.getOidFromRef project.get('_ref')
      projectSchema = project.get('SchemaVersion')
      @url = "#{appConfig.almWebServiceBaseUrl}/schema/@@WSAPI_VERSION/project/#{projectOid}/#{projectSchema}"

      @fetch(accepts: json: 'text/plain').then =>
        @updateModelsFromSchema()

    updateModelsFromSchema: ->
      $.when.apply($, 
        _.map [Defect, Task, UserStory, Initiative], (m) =>
          typePath = m::typePath
          model = @find (model) -> model.get('TypePath').toLowerCase() == typePath

          allowedValues = []

          if model
            m::fields = {}
            attributes = model.get('Attributes')

            _.each attributes, (attr) => m::fields[attr.ElementName] = {Name: attr.Name}
            
            allowedValues = _.map(
              _.filter(attributes, (attr) => attr.ElementName in m::allowedValueFields),
              @_getAttributeAllowedValues,
              this
            )

          $.when.apply($, allowedValues).then (values...) =>
            m::allowedValues = _.object values
      )

    _getAttributeAllowedValues: (attr) ->
      return if _.isArray attr.AllowedValues
        [attr.ElementName, _.map(attr.AllowedValues, (value) -> _.extend(value, AllowedValueType: attr.AllowedValueType))]
      else
        av = new AllowedValues()
        av.clientMetricsParent = this
        av.url = attr.AllowedValues._ref
        av.fetch().then -> [attr.ElementName, av.map((value) -> _.extend(value.toJSON(), AllowedValueType: attr.AllowedValueType))]
